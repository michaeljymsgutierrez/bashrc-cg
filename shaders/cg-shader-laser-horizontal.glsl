float getSdfRectangle(in vec2 p, in vec2 xy, in vec2 b)
{
    vec2 d = abs(p - xy) - b;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

// SDF for underscore (horizontal line at bottom)
float getSdfUnderscore(in vec2 p, in vec2 cursorPos, in vec2 cursorSize) {
    // Create a thin horizontal line at the bottom
    vec2 underscoreCenter = vec2(cursorPos.x, cursorPos.y - cursorSize.y * 0.5);
    vec2 underscoreSize = vec2(cursorSize.x * 0.5, cursorSize.y * 0.05);
    return getSdfRectangle(p, underscoreCenter, underscoreSize);
}

vec2 norm(vec2 value, float isPosition) {
    return (value * 2.0 - (iResolution.xy * isPosition)) / iResolution.y;
}

float antialising(float distance) {
    return 1. - smoothstep(0., norm(vec2(2., 2.), 0.).x, distance);
}

vec2 getRectangleCenter(vec4 rectangle) {
    return vec2(rectangle.x + (rectangle.z / 2.), rectangle.y - (rectangle.w / 2.));
}

float ease(float x) {
    return pow(1.0 - x, 3.0);
}

// Hash function for pseudo-random numbers
float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453123);
}

// Generate lightning bolt segments
vec2 getLightningOffset(float t, float seed) {
    float angle = (hash(vec2(t * 10.0, seed)) - 0.5) * 3.14159 * 0.3;
    float dist = hash(vec2(t * 7.0, seed + 1.0)) * 0.05;
    return vec2(cos(angle), sin(angle)) * dist;
}

// Distance to lightning bolt
float getLightningDistance(vec2 p, vec2 start, vec2 end, float time, float seed) {
    float minDist = 1000.0;
    int segments = 8;
    
    for (int i = 0; i < segments; i++) {
        float t0 = float(i) / float(segments);
        float t1 = float(i + 1) / float(segments);
        
        vec2 p0 = mix(start, end, t0) + getLightningOffset(t0, seed + time);
        vec2 p1 = mix(start, end, t1) + getLightningOffset(t1, seed + time);
        
        // Distance to segment
        vec2 pa = p - p0;
        vec2 ba = p1 - p0;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        float dist = length(pa - ba * h);
        
        minDist = min(minDist, dist);
    }
    
    return minDist;
}

// Generate sparks along the lightning
float getSparks(vec2 p, vec2 start, vec2 end, float time, float seed) {
    float sparkIntensity = 0.0;
    int numSparks = 12;
    
    for (int i = 0; i < numSparks; i++) {
        float t = float(i) / float(numSparks);
        float sparkTime = time * 60.0 + float(i) * 0.5;
        
        // Position along the main bolt
        vec2 sparkPos = mix(start, end, t);
        sparkPos += getLightningOffset(t, seed + sparkTime);
        
        // Random direction for spark
        float angle = hash(vec2(float(i), seed)) * 6.28318;
        float sparkLength = hash(vec2(float(i) + 0.5, seed)) * 0.03 + 0.01;
        
        // Animate spark length
        float sparkAnim = fract(sparkTime);
        sparkLength *= smoothstep(0.0, 0.3, sparkAnim) * (1.0 - smoothstep(0.3, 1.0, sparkAnim));
        
        vec2 sparkEnd = sparkPos + vec2(cos(angle), sin(angle)) * sparkLength;
        
        // Distance to spark
        vec2 pa = p - sparkPos;
        vec2 ba = sparkEnd - sparkPos;
        float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
        float dist = length(pa - ba * h);
        
        sparkIntensity += exp(-dist * 300.0) * (1.0 - sparkAnim);
    }
    
    return sparkIntensity;
}

const vec4 TRAIL_COLOR = vec4(1.0, 1.0, 0.0, 1.0); // Yellow
const vec4 GLOW_COLOR = vec4(1.0, 1.0, 0.8, 1.0); // Light yellow core
const float DURATION = 0.5;
const float LINE_THICKNESS = 0.002;
const float GLOW_THICKNESS = 0.015;

void mainImage(out vec4 fragColor, in vec2 fragCoord)
{
    fragColor = texture(iChannel0, fragCoord.xy / iResolution.xy);
    vec2 vu = norm(fragCoord, 1.);
    vec2 offsetFactor = vec2(-.5, 0.5);

    vec4 currentCursor = vec4(norm(iCurrentCursor.xy, 1.), norm(iCurrentCursor.zw, 0.));
    vec4 previousCursor = vec4(norm(iPreviousCursor.xy, 1.), norm(iPreviousCursor.zw, 0.));

    vec2 centerCC = getRectangleCenter(currentCursor);
    vec2 centerCP = getRectangleCenter(previousCursor);

    float progress = clamp((iTime - iTimeCursorChange) / DURATION, 0.0, 1.0);
    float easedProgress = ease(progress);
    float lineLength = distance(centerCC, centerCP);

    // Create multiple lightning bolts for more intensity
    float lightningDist = 1000.0;
    float seed = floor(iTimeCursorChange * 10.0);
    
    // Main bolt
    lightningDist = min(lightningDist, getLightningDistance(vu, centerCP, centerCC, iTime * 80.0, seed));
    
    // Secondary bolts
    lightningDist = min(lightningDist, getLightningDistance(vu, centerCP, centerCC, iTime * 100.0, seed + 10.0) + 0.001);
    lightningDist = min(lightningDist, getLightningDistance(vu, centerCP, centerCC, iTime * 120.0, seed + 20.0) + 0.002);
    
    // Add sparks
    float sparkIntensity = getSparks(vu, centerCP, centerCC, iTime, seed);

    float sdfCurrentCursor = getSdfUnderscore(vu, currentCursor.xy, currentCursor.zw);

    // Create glow effect
    float glowIntensity = exp(-lightningDist / GLOW_THICKNESS) * 0.5;
    float coreIntensity = smoothstep(LINE_THICKNESS, 0.0, lightningDist);
    
    // Flickering effect
    float flicker = 0.7 + 0.3 * sin(iTime * 200.0 + seed);
    
    // Fade along the bolt
    vec2 pa = vu - centerCP;
    vec2 ba = centerCC - centerCP;
    float h = clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
    float fadeFactor = 1.0 - h * 0.5;

    vec4 newColor = fragColor;
    
    // Apply lightning effect
    vec4 lightningColor = mix(TRAIL_COLOR, GLOW_COLOR, coreIntensity);
    lightningColor *= fadeFactor * flicker;
    
    newColor = mix(newColor, lightningColor, glowIntensity);
    newColor += GLOW_COLOR * coreIntensity * fadeFactor * flicker;
    
    // Add sparks
    newColor += GLOW_COLOR * sparkIntensity * fadeFactor;
    
    // Draw current cursor with glow
    newColor = mix(newColor, TRAIL_COLOR * 1.5, antialising(sdfCurrentCursor) * 0.7);
    newColor = mix(newColor, fragColor, step(sdfCurrentCursor, 0.));
    
    fragColor = mix(fragColor, newColor, step(sdfCurrentCursor, easedProgress * lineLength));
}
