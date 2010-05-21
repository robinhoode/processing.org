import javax.swing.*; 
 
class FileChooser {
  String choose(PApplet applet) {
    // set system look and feel 
    try { 
      UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); 
    } 
    catch (Exception e) { 
      e.printStackTrace();  
    } 
     
    // create a file chooser 
    final JFileChooser fc = new JFileChooser(); 
     
    // in response to a button click: 
    int returnVal = fc.showOpenDialog(applet); 
     
    if (returnVal == JFileChooser.APPROVE_OPTION) { 
      File file = fc.getSelectedFile(); 
      return file.getPath();
    }  
    else {
      return "Open command cancelled by user.";
    } 
  }
}
