// Author: Michael Jyms Gutierrez

float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

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
    float condition1 = step(b.x, a.x) * step(a.y, b.y);
    float condition2 = step(a.x, b.x) * step(b.y, a.y);

    return 1.0 - max(condition1, condition2);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

vec4 saturate(vec4 color, float factor) {
    float gray = dot(color, vec4(0.299, 0.587, 0.114, 0.));
    return mix(vec4(gray), color, factor);
}

float hash(vec2 p) {
    p = fract(p * vec2(123.34, 456.21));
    p += dot(p, p + 45.32);
    return fract(p.x * p.y);
}

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
const float DURATION = 1.0;
const float LINE_THICKNESS = 0.5;
const float LIGHTNING_INTENSITY = 1.5;
const float GLOW_SIZE = 5.0;
const float BRANCH_SCALE = 8.0;

const float STATIC_TIME = 0.0; 
const float LOADING_SPEED = 0.5;

const float LINE_SPACING = 0.005; 
const float LINE_FLICKER_SPEED = 1.0;
const float LINE_THRESHOLD = 0.5;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    vec4 finalColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    
    vec2 vu = norm(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);

    float sdfCurrentCursor = getSdfRectangle(vu, currentCursor.xy - (currentCursor.zw * offsetFactor), currentCursor.zw * 0.5);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0); 
    float easedProgress = ease(progress);

    vec3 coreColor = vec3(1.0, 1.0, 0.7);
    vec3 glowColor = vec3(1.0, 0.9, 0.2);
    vec3 lightningColor = mix(glowColor, coreColor, 1.0); 
    
    float glowSize = norm(vec2(GLOW_SIZE, GLOW_SIZE), 0.).x;
    
    vec4 newColor = vec4(finalColor);
    
    // ============================================
    // EDGE GLOW EFFECTS CONFIGURATION
    // ============================================
    const float BASE_GLOW_SPREAD = 200.0;
    const float GLOW_INTENSITY = 1.0;
    const float WAVE_SCALE = 15.0; 
    
    // ============================================
    // BOTTOM EDGE GLOW EFFECT (Horizontal Lines)
    // ============================================
    float loadingMovement = sin(vu.x * WAVE_SCALE + iTime * LOADING_SPEED) * 0.5 + 0.5; 

    const float WIDTH_NOISE_SCALE = 10.0;
    const float WIDTH_NOISE_SPEED = 0.5;
    float widthNoise = lightningNoise(vec2(vu.x * WIDTH_NOISE_SCALE, iTime * WIDTH_NOISE_SPEED), 456.0);
    float dynamicGlowSpread = BASE_GLOW_SPREAD * mix(0.5, 1.5, widthNoise); 

    float totalBottomGlow = 0.0;
    
    // Create 3 horizontal glowing lines at the bottom edge
    for(int i = 0; i < 3; i++) {
        float lineNudge = float(i) * norm(vec2(LINE_SPACING, 0.0), 0.0).x;
        
        // Distance from bottom edge (y = -1.0 is bottom in normalized coords)
        float distFromLine = max(0.0, vu.y - (-1.0 + lineNudge));
        
        float lineGlow = exp(-distFromLine * dynamicGlowSpread) * GLOW_INTENSITY;
        
        float noiseSeed = float(i) * 10.0 + 456.0;
        // Flicker along horizontal (x) axis
        float flickerValue = lightningNoise(vec2(vu.x * 0.1, iTime * LINE_FLICKER_SPEED * 0.5), noiseSeed);
        
        float activationMask = clamp(flickerValue * 2.0 - 1.0, 0.0, 1.0); 

        if (i == 0) {
            activationMask = max(activationMask, 0.2);
        }

        totalBottomGlow += lineGlow * loadingMovement * activationMask;
    }
    
    // ============================================
    // RIGHT EDGE GLOW EFFECT (Vertical Lines)
    // ============================================
    float aspectRatio = iResolution.x / iResolution.y;
    // Wave moves vertically (y) along the right edge
    float loadingMovementRight = sin(vu.y * WAVE_SCALE + iTime * LOADING_SPEED) * 0.5 + 0.5;
    float widthNoiseRight = lightningNoise(vec2(vu.y * WIDTH_NOISE_SCALE, iTime * WIDTH_NOISE_SPEED), 789.0);
    float dynamicGlowSpreadRight = BASE_GLOW_SPREAD * mix(0.5, 1.5, widthNoiseRight);
    
    float totalRightGlow = 0.0;
    
    // Create 3 vertical glowing lines at the right edge
    for(int i = 0; i < 3; i++) {
        float lineNudge = float(i) * norm(vec2(LINE_SPACING, 0.0), 0.0).x;
        
        // Right edge position based on aspect ratio
        float rightEdge = aspectRatio;
        // Distance from right edge
        float distFromLine = max(0.0, (rightEdge - lineNudge) - vu.x);
        
        float lineGlow = exp(-distFromLine * dynamicGlowSpreadRight) * GLOW_INTENSITY;
        
        float noiseSeed = float(i) * 10.0 + 789.0;
        // Flicker along vertical (y) axis
        float flickerValue = lightningNoise(vec2(vu.y * 0.1, iTime * LINE_FLICKER_SPEED * 0.5), noiseSeed);
        
        float activationMask = clamp(flickerValue * 2.0 - 1.0, 0.0, 1.0); 

        if (i == 0) {
            activationMask = max(activationMask, 0.2);
        }

        totalRightGlow += lineGlow * loadingMovementRight * activationMask;
    }
    
    // ============================================
    // LEFT EDGE GLOW EFFECT (Vertical Lines)
    // ============================================
    // Wave moves vertically (y) along the left edge
    // Wave moves vertically (y) along the left edge
    float loadingMovementLeft = sin(vu.y * WAVE_SCALE + iTime * LOADING_SPEED) * 0.5 + 0.5;
    float widthNoiseLeft = lightningNoise(vec2(vu.y * WIDTH_NOISE_SCALE, iTime * WIDTH_NOISE_SPEED), 123.0);
    float dynamicGlowSpreadLeft = BASE_GLOW_SPREAD * mix(0.5, 1.5, widthNoiseLeft);
    
    float totalLeftGlow = 0.0;
    
    // Create 3 vertical glowing lines at the left edge
    for(int i = 0; i < 3; i++) {
        float lineNudge = float(i) * norm(vec2(LINE_SPACING, 0.0), 0.0).x;
        
        // Left edge position (negative aspect ratio)
        float leftEdge = -aspectRatio;
        // Distance from left edge
        float distFromLine = max(0.0, vu.x - (leftEdge + lineNudge));
        
        float lineGlow = exp(-distFromLine * dynamicGlowSpreadLeft) * GLOW_INTENSITY;
        
        float noiseSeed = float(i) * 10.0 + 123.0;
        // Flicker along vertical (y) axis
        float flickerValue = lightningNoise(vec2(vu.y * 0.1, iTime * LINE_FLICKER_SPEED * 0.5), noiseSeed);
        
        float activationMask = clamp(flickerValue * 2.0 - 1.0, 0.0, 1.0); 

        if (i == 0) {
            activationMask = max(activationMask, 0.2);
        }

        totalLeftGlow += lineGlow * loadingMovementLeft * activationMask;
    }
    
    // ============================================
    // COMBINE ALL EDGE GLOWS
    // ============================================
    finalColor.rgb += lightningColor * (totalBottomGlow + totalRightGlow + totalLeftGlow); 

    vec4 trail = iCurrentCursorColor;
    trail = saturate(trail, 2.5);
    
    float cursorGlow = exp(-abs(sdfCurrentCursor) / glowSize) * 0.8;
    newColor.rgb += lightningColor * cursorGlow;
    newColor = mix(newColor, trail, antialising(sdfCurrentCursor));
    newColor = mix(newColor, finalColor, step(sdfCurrentCursor, 0.));
    
    finalColor = mix(finalColor, newColor, antialising(sdfCurrentCursor)); 
    
    fragColor = finalColor;
}
