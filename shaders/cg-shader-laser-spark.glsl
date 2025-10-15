// Author: Michael Jyms Gutierrez

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance, float normFactor) {
    return 1.0 - smoothstep(0.0, normFactor, distance);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + rectangle.z * 0.5, rectangle.y - rectangle.w * 0.5);
}

float ease(float x) {
    float t = 1.0 - x;
    return t * t * t;
}

vec4 saturate(vec4 color, float factor) {
    float gray = dot(color.rgb, vec3(0.299, 0.587, 0.114));
    return mix(vec4(gray), color, factor);
}

// Optimized hash function
float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

// Simplified noise function - fewer operations
float lightningNoise(vec2 p, float seed) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    
    float a = hash(i + seed);
    float b = hash(i + vec2(1.0, 0.0) + seed);
    float c = hash(i + vec2(0.0, 1.0) + seed);
    float d = hash(i + vec2(1.0, 1.0) + seed);
    
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(a, b, u.x), mix(c, d, u.x), u.y);
}

const float OPACITY = 0.6;
const float DURATION = 0.3;
const float LINE_THICKNESS = 0.5;
const float LIGHTNING_INTENSITY = 1.5;
const float GLOW_SIZE = 5.0;
const float BRANCH_SCALE = 8.0;

const float LOADING_SPEED = 0.5;
const float LINE_SPACING = 0.005; 
const float LINE_FLICKER_SPEED = 1.0;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    // 1. Pre-calculate common values
    vec2 invResolution = 1.0 / iResolution.xy;
    vec4 rawBgColor = texture(iChannel0, fragCoord * invResolution);
    
    vec2 vu = norm(fragCoord, 1.0);
    vec2 offsetFactor = vec2(-0.5, 0.5);

    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.0), norm(iCurrentCursor.zw, 0.0));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.0), norm(iPreviousCursor.zw, 0.0));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);

    // Get time/progress variables
    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);

    // Distance fields - optimized calculations
    vec2 pa = vu - centerCP;
    vec2 ba = centerCC - centerCP;
    float baDot = dot(ba, ba);
    float h = clamp(dot(pa, ba) / baDot, 0.0, 1.0);
    
    float normThickness = norm(vec2(LINE_THICKNESS, LINE_THICKNESS), 0.0).x;
    float sdfTrail = length(pa - ba * h) - normThickness;
    
    vec2 cursorOffset = currentCursor.zw * offsetFactor;
    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - cursorOffset, currentCursor.zw * 0.5);

    // Lightning colors - pre-calculated
    vec3 coreColor = vec3(1.0, 1.0, 0.7);
    vec3 glowColor = vec3(1.0, 0.9, 0.2);
    vec3 lightningColor = mix(glowColor, coreColor, 1.0);
    float glowSize = norm(vec2(GLOW_SIZE, GLOW_SIZE), 0.0).x;
    
    // --------------------------------------------------------------------------------
    // Background Glow Effect (Bottom Edge) - Optimized
    // --------------------------------------------------------------------------------
    vec4 finalColor = rawBgColor;

    const float BASE_GLOW_SPREAD = 150.0;
    const float GLOW_INTENSITY = 2.5;
    const float WAVE_SCALE = 15.0;

    // Pre-calculate time-based values
    float timeSpeed = iTime * LOADING_SPEED;
    float loadingMovement = sin(vu.x * WAVE_SCALE + timeSpeed) * 0.5 + 0.5;

    // Dynamic width calculation
    const float WIDTH_NOISE_SCALE = 10.0;
    const float WIDTH_NOISE_SPEED = 0.5;
    float widthNoise = lightningNoise(vec2(vu.x * WIDTH_NOISE_SCALE, iTime * WIDTH_NOISE_SPEED), 456.0);
    float dynamicGlowSpread = BASE_GLOW_SPREAD * mix(0.5, 1.5, widthNoise);

    // Generate vertical glow for multiple lines
    float totalBottomGlow = 0.0;
    float lineSpacing = norm(vec2(LINE_SPACING, 0.0), 0.0).x;
    float flickerTime = iTime * LINE_FLICKER_SPEED * 0.5;
    
    for(int i = 0; i < 3; i++) {
        float lineNudge = float(i) * lineSpacing;
        float distFromLine = max(0.0, 1.0 - lineNudge - vu.y);
        float lineGlow = exp(-distFromLine * dynamicGlowSpread) * GLOW_INTENSITY;
        
        float noiseSeed = float(i) * 10.0 + 456.0;
        float flickerValue = lightningNoise(vec2(vu.x * 0.1, flickerTime), noiseSeed);
        float activationMask = clamp(flickerValue * 2.0 - 1.0, 0.0, 1.0);
        
        if (i == 0) activationMask = max(activationMask, 0.2);

        totalBottomGlow += lineGlow * loadingMovement * activationMask;
    }
    
    finalColor.rgb += lightningColor * totalBottomGlow;
    
    // --------------------------------------------------------------------------------
    // Cursor/Trail Lightning Effect - Optimized
    // --------------------------------------------------------------------------------
    
    // Lightning effect setup
    float baLength = sqrt(baDot);
    vec2 perpendicular = vec2(-ba.y, ba.x) / baLength;
    float distAlongLine = dot(pa, ba) / baLength;
    float distFromLine = abs(dot(pa, perpendicular));
    
    // Simplified lightning pattern with fewer noise calls
    float time10 = iTime * 10.0;
    float noise = lightningNoise(vec2(distAlongLine * BRANCH_SCALE, time10), iTime);
    noise += lightningNoise(vec2(distAlongLine * BRANCH_SCALE * 2.0, iTime * 5.0), iTime + 100.0) * 0.5;
    
    // Branches
    float branches = step(0.7, noise) * (1.0 - smoothstep(0.0, 0.02, distFromLine));
    
    // Main lightning bolt
    float displacement = (noise - 0.5) * 0.003;
    float lightningCore = smoothstep(0.002, 0.0, distFromLine + displacement);
    
    // Electric glow
    float glow = exp(-distFromLine / glowSize) * 0.6;
    
    // Combine lightning effects
    float lightning = max(lightningCore, branches * 0.5) + glow;
    
    vec3 trailLightningColor = mix(glowColor, coreColor, lightningCore);
    
    // Optimized flickering
    lightning *= 0.8 + 0.2 * sin(iTime * 50.0 + distAlongLine * 20.0);

    // Simplified sparks (fewer hash calls)
    float time8 = floor(iTime * 8.0);
    float sparkNoise = hash(vec2(distAlongLine * 15.0, time8));
    float sparkChance = step(0.85, sparkNoise);
    
    float sparkProgress = fract(iTime * 3.0);
    vec2 sparkDirection = normalize(vec2(
        hash(vec2(distAlongLine * 10.0, floor(iTime * 5.0))) - 0.5,
        hash(vec2(distAlongLine * 12.0, floor(iTime * 5.0) + 50.0)) - 0.5
    ));
    
    vec2 sparkPos = (ba * h) + sparkDirection * sparkProgress * 0.03;
    float sparkDist = length(pa - sparkPos);
    
    float sparkPattern = lightningNoise(vec2(sparkDist * 100.0, iTime * 15.0), iTime + distAlongLine);
    float sparkLine = smoothstep(0.003, 0.0, sparkDist + (sparkPattern - 0.5) * 0.002);
    
    float spark = sparkChance * sparkLine * (1.0 - sparkProgress) * 0.8;
    
    vec4 newColor = finalColor;
    
    // Apply lightning to trail
    float trailMask = 1.0 - smoothstep(0.0, 0.02, sdfTrail);
    newColor.rgb += trailLightningColor * lightning * LIGHTNING_INTENSITY * trailMask;
    newColor.rgb += trailLightningColor * spark * 3.0;

    vec4 trail = saturate(iCurrentCursorColor, 2.5);
    
    // Draw trail base
    float normFactor = norm(vec2(2.0, 2.0), 0.0).x;
    newColor = mix(newColor, trail, antialising(sdfTrail, normFactor) * 0.3);
    
    // Draw current cursor with glow
    float cursorGlow = exp(-abs(sdfCurrentCursor) / glowSize) * 0.8;
    newColor.rgb += lightningColor * cursorGlow;
    newColor = mix(newColor, trail, antialising(sdfCurrentCursor, normFactor));
    newColor = mix(newColor, finalColor, step(sdfCurrentCursor, 0.0));
    
    // Final blend
    fragColor = mix(finalColor, newColor, step(sdfCurrentCursor, easedProgress * baLength));
}
