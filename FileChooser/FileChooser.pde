/**
filechooser taken from http://processinghacks.com/hacks:filechooser
@author Tom Carden
*/
 
import javax.swing.*; 
 
void setup() {
   
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
  int returnVal = fc.showOpenDialog(this); 
   
  if (returnVal == JFileChooser.APPROVE_OPTION) { 
    File file = fc.getSelectedFile(); 
    println(file.getPath());
  }  
  else { 
    println("Open command cancelled by user."); 
  }
}
