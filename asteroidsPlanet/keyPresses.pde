/* @pjs globalKeyEvents="true"; */

/**
 *  Helpful links:
 *    http://stackoverflow.com/questions/14104316/java-equivalent-for-charcodeat
 *    http://stackoverflow.com/questions/94037/convert-character-to-ascii-code-in-javascript
 *    http://wiki.processing.org/w/Multiple_key_presses
 */

// 526 is used in the official processing wiki ..
// not sure why, but i'll stick with it even if extended ascii stops at 255
boolean[] keys = new boolean[526];

//                     UP    DOWN   LEFT   RIGHT   ALT  CONTROL SHIFT
boolean[] codedKeys= {false, false, false, false, false, false, false};


boolean checkKey(String k) {
  String[] m1 = match(k.toUpperCase(), "UP|DOWN|LEFT|RIGHT|ALT|CONTROL|SHIFT|SPACE|SPACEBAR|BACKSPACE|TAB|ENTER|RETURN|ESC|DELETE");
  if (m1 != null) {

    // check coded (non-ascii) special keyCodes
    if (m1[0].equals("UP")) {
      return codedKeys[0];
    } else if (m1[0].equals("DOWN")) {
      return codedKeys[1];
    } else if (m1[0].equals("LEFT")) {
      return codedKeys[2];
    } else if (m1[0].equals("RIGHT")) {
      return codedKeys[3];
    } else if (m1[0].equals("ALT")) {
      return codedKeys[4];
    } else if (m1[0].equals("CONTROL")) {
      return codedKeys[5];
    } else if (m1[0].equals("SHIFT")) {
      return codedKeys[6];
    }

    // check non-coded (ascii) special keyCodes
    // BACKSPACE, TAB, ENTER, RETURN, ESC, and DELETE.
    // SPACE is not a special code, but devs would need to check for " ", and "SPACE" is more logical
    if (m1[0].equals("SPACE")) {
      return keys[32];
    } else if (m1[0].equals("SPACEBAR")) {
      return keys[32];
    } else if (m1[0].equals("BACKSPACE")) {
      return keys[BACKSPACE];
    } else if (m1[0].equals("TAB")) {
      return keys[TAB];
    } else if (m1[0].equals("ENTER")) {
      return keys[ENTER] || keys[RETURN];
    } else if (m1[0].equals("RETURN")) {
      return keys[RETURN] || keys[ENTER];
    } else if (m1[0].equals("ESC")) {
      return keys[ESC];
    } else if (m1[0].equals("DELETE")) {
      return keys[DELETE];
    }
  }

  // for single-character keys
  if (k.length() == 1) {
    return (k.codePointAt(0) < keys.length) && keys[k.codePointAt(0)];
  }

  return false;
}

void keyPressed () {
  if (key == CODED) {
    if (keyCode == UP) {
      codedKeys[0] = true;
    } else if (keyCode == DOWN) {
      codedKeys[1] = true;
    } else if (keyCode == LEFT) {
      codedKeys[2] = true;
    } else if (keyCode == RIGHT) {
      codedKeys[3] = true;
    } else if (keyCode == ALT) {
      codedKeys[4] = true;
    } else if (keyCode == CONTROL) {
      codedKeys[5] = true;
    } else if (keyCode == SHIFT) {
      codedKeys[6] = true;
    }

    return;
  }

  String k = str(key);

  if (k.codePointAt(0) < keys.length) {
    keys[k.codePointAt(0)] = true;
  }
}

void keyReleased () {
  if (key == CODED) {
    if (keyCode == UP) {
      codedKeys[0] = false;
    } else if (keyCode == DOWN) {
      codedKeys[1] = false;
    } else if (keyCode == LEFT) {
      codedKeys[2] = false;
    } else if (keyCode == RIGHT) {
      codedKeys[3] = false;
    } else if (keyCode == ALT) {
      codedKeys[4] = false;
    } else if (keyCode == CONTROL) {
      codedKeys[5] = false;
    } else if (keyCode == SHIFT) {
      codedKeys[6] = false;
    }

    return;
  }

  String k = str(key);

  if (k.codePointAt(0) < keys.length) {
    keys[k.codePointAt(0)] = false;
  }
}
