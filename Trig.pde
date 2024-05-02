int mode = 0; // Current motion mode
float theta = 0.0;
float amp = 100;
float freq = PI / 180;
float boxSize = 50; // Initial size of the box
boolean trails = true; // Toggle for trails

String[] formulas = {
  "Spiral: x = cos(θ) * (A + θ/10), y = sin(θ) * (A + θ/10)",
  "Harmonic Oscillations: x = sin(θ) * A * exp(-0.05 * θ), y = cos(θ) * A * exp(-0.05 * θ)",
  "Lissajous Curves: x = sin(θ * 3), y = sin(θ * 4 + π/2)",
  "Superellipse: x = |cos(θ)|^(2/4) * A * sgn(cos(θ)), y = |sin(θ)|^(2/4) * A * sgn(sin(θ))",
  "Noise-based Motion: x = noise(θ * 0.1) * 300 - 150, y = noise((θ + 1000) * 0.1) * 300 - 150",
  "Rose Curve: r = 200 * cos(5 * θ), x = r * cos(θ), y = r * sin(θ)",
  "Butterfly Curve: x = sin(t) * (exp(cos(t)) - 2cos(4t) - sin(t/12)^5), y = cos(t) * (exp(cos(t)) - 2cos(4t) - sin(t/12)^5)",
  "Fermat's Spiral: r = ±sqrt(θ), x = r * cos(θ), y = r * sin(θ)",
  "Maurer Rose: r = 200 * sin(6 * θ), Connect (r, θ) to (r, θ + 0.1)",
  "Hypotrochoid: x = (R - r) * cos(θ) + d * cos((R - r) / r * θ), y = (R - r) * sin(θ) - d * sin((R - r) / r * θ)"
};
String instructions = "Keys 0-9: Change motion | T: Toggle trails | +/-: Adjust size | Arrows: Adjust speed";

void setup() {
  size(600, 600);
  background(255);
  textSize(18); // Set text size for formulas
  println("Interactive controls:");
  println(instructions);
}

void draw() {
  if (trails) {
    fill(255, 2); // Fading background for trails
    rect(0, 0, width, height);
  } else {
    background(255); // Clear background if trails are off
  }

  translate(width / 2, height / 2);
  float boxX = 0, boxY = 0;
  float r = 0; // Declared once, used in multiple cases

  switch (mode) {
    case 0: // Spiral
      boxX = cos(theta) * (amp + theta/10);
      boxY = sin(theta) * (amp + theta/10);
      break;
    case 1: // Harmonic Oscillations
      boxX = sin(theta) * amp * exp(-0.05 * theta);
      boxY = cos(theta) * amp * exp(-0.05 * theta);
      break;
    case 2: // Lissajous Curves
      boxX = sin(theta * 3) * amp;
      boxY = sin(theta * 4 + PI/2) * amp;
      break;
    case 3: // Superellipse
      boxX = pow(abs(cos(theta)), 2/4) * amp * sign(cos(theta));
      boxY = pow(abs(sin(theta)), 2/4) * amp * sign(sin(theta));
      break;
    case 4: // Noise-based Motion
      boxX = noise(theta * 0.1) * 300 - 150;
      boxY = noise((theta + 1000) * 0.1) * 300 - 150;
      break;
    case 5: // Rose Curve
      r = 200 * cos(5 * theta);
      boxX = r * cos(theta);
      boxY = r * sin(theta);
      break;
case 6: // Dramatically Enhanced Butterfly Curve
    // Increase the range of theta to see more of the curve
    theta += 0.05;  // Adjusting the speed of theta increment

    // Applying more dramatic dynamic changes
    float timeFactor = millis() * 0.0005;  // Increase time impact
    boxX = sin(theta) * (exp(cos(theta + timeFactor)) - 1 * cos(4 * theta) - pow(sin((theta / 120 + timeFactor)), 1)) * 10;
    boxY = cos(theta) * (exp(cos(theta + timeFactor)) - 1 * cos(4 * theta) - pow(sin((theta / 120 + timeFactor)), 1)) * 10;
    break;


case 7: // Dramatically Enhanced Fermat's Spiral
    // Speed up the incrementation of theta and allow it to grow indefinitely
    theta += 0.01;  // Increase theta faster to cover more area

    // Dynamically increase the scale of the spiral based on time
    r = sqrt(theta) * (1.0 + 0.1 * sin(millis() * 0.0001));  // Dynamic scaling
    boxX = r * cos(theta) * 50;  // Scale up the x coordinates
    boxY = r * sin(theta) * 50;  // Scale up the y coordinates
    break;


    case 8: // Maurer Rose
      r = 200 * sin(6 * theta);
      float r2 = 200 * sin(6 * (theta + 0.1));
      float theta2 = theta + 0.1;
      float boxX2 = r2 * cos(theta2);
      float boxY2 = r2 * sin(theta2);
      line(boxX, boxY, boxX2, boxY2);
      break;
       case 9: // Hypotrochoid
      float R = 125, smallR = 75, d = 125; // Renamed 'r' to 'smallR' to avoid conflict
      boxX = (R - smallR) * cos(theta) + d * cos((R - smallR) / smallR * theta);
      boxY = (R - smallR) * sin(theta) - d * sin((R - smallR) / smallR * theta);
      break;
  }

  if (mode != 8) { // Exclude Maurer Rose from normal rendering
    fill(360 * sin(theta), 100, 100);
    rect(boxX - boxSize / 2, boxY - boxSize / 2, boxSize, boxSize);
  }

  theta += freq;

  resetMatrix();
  fill(0);
  textSize(16);
  text(formulas[mode], 10, 20);
  textSize(12);
  fill(100);
  text(instructions, 10, height - 20);
}


void keyPressed() {
  if (key >= '0' && key <= '9') {
    mode = key - '0';
  } else if (key == 'T' || key == 't') {
    trails = !trails;
  } else if (key == '+' || key == '=') {
    boxSize += 5;
  } else if (key == '-' && boxSize > 5) {
    boxSize -= 5;
  } else if (key == CODED) {
    if (keyCode == UP) {
      freq += PI / 360;
    } else if (keyCode == DOWN) {
      freq -= PI / 360;
      if (freq < 0) freq = 0;
    }
  }
}

// Utility function for signum
float sign(float x) {
  return x < 0 ? -1 : 1;
}
