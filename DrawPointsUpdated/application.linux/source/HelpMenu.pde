class HelpMenu {
  String[] helpText;
  boolean showing;
  PVector position;
  
  HelpMenu(String[] helpText) {
    this.showing  = true;
    this.helpText = helpText;
    this.position = new PVector(20, 20);
  }
  
  void draw() {    
    background(0);
    fill(40);
    rect(position.x-5, position.y-15, longestLine()*7 + 8, helpText.length*16 + 16);
    fill(255);
    for (int i = 0; i < helpText.length; i++)
      text(helpText[i], position.x, i*16 + position.y);
  }
  
  int longestLine() {
    int max = 0;
    for (int i = 0; i < helpText.length; i++) {
      if (helpText[i].length() > max)
        max = helpText[i].length();
    }
    return max;
  }
}

