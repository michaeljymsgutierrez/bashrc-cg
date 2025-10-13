float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// Based on Inigo Quilez's 2D distance functions article: https://iquilezles.org/articles/distfunctions2d/
// Potencially optimized by eliminating conditionals and loops to enhance performance and reduce branching

float seg(in vec2 p, in vec2 a, in vec2 b, inout float s, float d) {
    vec2 e = b - a;
    vec2 w = p - a;
    vec2 proj = a + e * clamp(dot(w, e) / dot(e, e), 0.0, 1.0);
    float segd = dot(p - proj, p - proj);
    d = min(d, segd);

    float c0 = step(0.0, p.y - a.y);
    float c1 = 1.0 - step(0.0, p.y - b.y);
    float c2 = 1.0 - step(0.0, e.x * w.y - e.y * w.x);
    float allCond = c0 * c1 * c2;
    float noneCond = (1.0 - c0) * (1.0 - c1) * (1.0 - c2);
    float flip = mix(1.0, -1.0, step(0.5, allCond + noneCond));
    s *= flip;
    return d;
}

float getSdfParallelogram(in vec2 p, in vec2 v0, in vec2 v1, in vec2 v2, in vec2 v3) {
    float s = 1.0;
    float d = dot(p - v0, p - v0);

    d = seg(p, v0, v3, s, d);
    d = seg(p, v1, v0, s, d);
    d = seg(p, v2, v1, s, d);
    d = seg(p, v3, v2, s, d);

    return s * sqrt(d);
}

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1. - smoothstep(0., norm(vec2(2., 2.), 0.).x, distance);
}

float determineStartVertexFactor(vec2 a, vec2 b) {
    // Conditions using step
    float condition1 = step(b.x, a.x) * step(a.y, b.y); // a.x < b.x && a.y > b.y
    float condition2 = step(a.x, b.x) * step(b.y, a.y); // a.x > b.x && a.y < b.y

    // If neither condition is met, return 1 (else case)
    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

vec4 saturate(vec4 color, float factor) {
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.)); // luminance
    return mix(vec4(gray), color, factor);
}

// Hash function for noise
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Generate lightning branches
float lightningNoise(vec2 p, float seed) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i + seed);
    float b = hash(i + vec2(1.0, 0.0) + seed);
    float c = hash(i + vec2(0.0, 1.0) + seed);
    float d = hash(i + vec2(1.0, 1.0) + seed);
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

const float OPACITY = 0.6;
const float DURATION = 0.3; //IN SECONDS
const float LINE_THICKNESS = 0.5;
const float LIGHTNING_INTENSITY = 1.5;
const float GLOW_SIZE = 5.0;
const float BRANCH_SCALE = 8.0;

// Use a static time value for cursor-related effects
const float STATIC_TIME = 0.0; 
// Define loading effect speed
const float LOADING_SPEED = 2.0;

// --- NEW CONSTANTS FOR MULTI-LINE EFFECT ---
const float LINE_SPACING = 0.005; // Spacing between lines (normalized by yResolution)
const float LINE_FLICKER_SPEED = 10.0; // Speed of the random line activation
const float LINE_THRESHOLD = 0.5; // Probability threshold for a line being 'on' (lower=more lines)

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // Start with the background color
    vec4 finalColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    
    vec2 vu = norm(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);

    // Line segment distance calculation
    vec2 pa = vu - centerCP;
    vec2 ba = centerCC - centerCP;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    float sdfTrail = length(pa - ba * h) - norm(vec2(LINE_THICKNESS, LINE_THICKNESS), 0.).x;

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0); 
    float easedProgress = ease(progress);
    float lineLength = distance(centerCC, centerCP);

    // Lightning effect
    vec2 perpendicular = normalize(vec2(-ba.y, ba.x));
    float distAlongLine = dot(pa, ba) / length(ba);
    float distFromLine = abs(dot(pa, perpendicular));
    
    // Create jagged lightning pattern - Use STATIC_TIME
    float noise = lightningNoise(vec2(distAlongLine * BRANCH_SCALE, STATIC_TIME * 10.0), STATIC_TIME);
    noise += lightningNoise(vec2(distAlongLine * BRANCH_SCALE * 2.0, STATIC_TIME * 5.0), STATIC_TIME + 100.0) * 0.5;
    
    // Add branches
    float branches = step(0.7, noise) * (1.0 - smoothstep(0.0, 0.02, distFromLine));
    
    // Main lightning bolt with noise displacement
    float displacement = (noise - 0.5) * 0.003;
    float lightningCore = smoothstep(0.002, 0.0, distFromLine + displacement);
    
    // Electric glow
    float glowSize = norm(vec2(GLOW_SIZE, GLOW_SIZE), 0.).x;
    float glow = exp(-distFromLine / glowSize) * 0.6;
    
    // Combine lightning effects
    float lightning = max(lightningCore, branches * 0.5);
    lightning += glow;
    
    // Lightning colors - bright electric yellow
    vec3 coreColor = vec3(1.0, 1.0, 0.7);
    vec3 glowColor = vec3(1.0, 0.9, 0.2);
    vec3 lightningColor = mix(glowColor, coreColor, lightningCore);
    
    // Flickering effect - Static
    float flicker = 1.0; 
    lightning *= flicker;

    // Minimal sparks - Static
    float sparkNoise = hash(vec2(distAlongLine * 15.0, 0.0));
    float sparkChance = step(0.85, sparkNoise);
    
    vec2 sparkDirection = vec2(
        hash(vec2(distAlongLine * 10.0, 0.0)) - 0.5,
        hash(vec2(distAlongLine * 12.0, 50.0)) - 0.5
    );
    sparkDirection = normalize(sparkDirection);
    
    float sparkProgress = 0.5; 
    vec2 sparkPos = (ba * h) + sparkDirection * sparkProgress * 0.03;
    float sparkDist = length(pa - sparkPos);
    
    float sparkPattern = lightningNoise(vec2(length(pa - sparkPos) * 100.0, 0.0), 0.0 + distAlongLine);
    float sparkLine = smoothstep(0.003, 0.0, sparkDist + (sparkPattern - 0.5) * 0.002);
    
    float spark = sparkChance * sparkLine * (1.0 - sparkProgress) * 0.8;
    
    vec4 newColor = vec4(finalColor);
    
    // --------------------------------------------------------------------------------
    // --- PERMANENT MULTI-LINE, MOVING BOTTOM GLOWING LINE EFFECT (Random 1-3 Lines) ---
    // --------------------------------------------------------------------------------
    
    // Base parameters
    const float BASE_GLOW_SPREAD = 200.0;
    const float GLOW_INTENSITY = 1.0;
    const float WAVE_SCALE = 15.0; 
    
    // 1. Calculate Horizontal Movement Mask
    float loadingMovement = sin(vu.x * WAVE_SCALE + iTime * LOADING_SPEED) * 0.5 + 0.5; 

    // 2. Calculate Dynamic Width (Random thickness variation)
    const float WIDTH_NOISE_SCALE = 10.0;
    const float WIDTH_NOISE_SPEED = 0.5;
    float widthNoise = lightningNoise(vec2(vu.x * WIDTH_NOISE_SCALE, iTime * WIDTH_NOISE_SPEED), 456.0);
    float dynamicGlowSpread = BASE_GLOW_SPREAD * mix(0.5, 1.5, widthNoise); 

    // 3. Generate Vertical Glow for Multiple Lines
    float totalBottomGlow = 0.0;
    
    // Loop (or manually define) 3 distinct lines: 0 (bottommost), 1, and 2
    for(int i = 0; i < 3; i++) {
        // Line Nudge: Move the line up by an amount proportional to its index
        float lineNudge = float(i) * norm(vec2(LINE_SPACING, 0.0), 0.0).x;
        
        // Vertical Distance: Distance from the nudge position (1.0 - nudge)
        float distFromLine = max(0.0, (1.0 - lineNudge) - vu.y); 
        
        // Vertical Falloff (creates the sharp line)
        float lineGlow = exp(-distFromLine * dynamicGlowSpread) * GLOW_INTENSITY;
        
        // Random Activation/Flicker for this line
        // We hash the line index (i) and time to get a random value between 0 and 1
        float flickerValue = hash(vec2(float(i), iTime * LINE_FLICKER_SPEED));
        
        // Activation Mask: Line is 'on' if flickerValue is below the threshold
        float activationMask = smoothstep(LINE_THRESHOLD - 0.1, LINE_THRESHOLD + 0.1, flickerValue);

        // Ensure the absolute bottom line (i=0) is always on, or at least a minimum is applied
        if (i == 0) {
            activationMask = max(activationMask, 0.5); // Ensure the base line is usually visible
        }

        // Modulate line glow by horizontal movement AND random activation
        totalBottomGlow += lineGlow * loadingMovement * activationMask;
    }
    
    // 4. Apply the Total Glow
    finalColor.rgb += lightningColor * totalBottomGlow; 

    // --- END: MULTI-LINE GLOW ---
    
    // Apply lightning to trail
    float trailMask = 1.0 - smoothstep(0.0, 0.02, sdfTrail);
    newColor.rgb += lightningColor * lightning * LIGHTNING_INTENSITY * trailMask;
    
    // Add spark lightning bolts
    newColor.rgb += lightningColor * spark * 3.0;

    vec4 trail = iCurrentCursorColor;
    trail = saturate(trail, 2.5);
    
    // Draw trail base
    newColor = mix(newColor, trail, antialising(sdfTrail) * 0.3);
    
    // Draw current cursor with glow
    float cursorGlow = exp(-abs(sdfCurrentCursor) / glowSize) * 0.8;
    newColor.rgb += lightningColor * cursorGlow;
    newColor = mix(newColor, trail, antialising(sdfCurrentCursor));
    newColor = mix(newColor, finalColor, step(sdfCurrentCursor, 0.));
    
    // The final blend ensures cursor effects are drawn over the background and permanent glow.
    finalColor = mix(finalColor, newColor, step(sdfCurrentCursor, easedProgress * lineLength));
    
    fragColor = finalColor;
}
