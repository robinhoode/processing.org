/**
 * @package
 * InitSketchFromTemplate P5 Tool.
 * Initialize your sketches from a txt template
 * Copyright (C) 2009 Jonathan Acosta (aka 0p0).
 *
 * InitSketchFromTemplate P5 Tool is free software, you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * InitSketchFromTemplate P5 Tool is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package InitSketchFromTemplate;

import processing.app.Base; // Necessary to get the Sketchbook location
import processing.app.Editor;
import processing.app.tools.Tool;

// Java FileInputStream Handling
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;

/**
 * <p>This Tool subclass reads a template file you create and edit
 * to initialize the sketch you are currently working on;
 * This template file must be named "template.txt" and must be
 * put inside of the <i>sketchbook/tools/InitSketchFromTemplate/tool/</i>
 * folder. </p>
 * <p>If you put the template file somewhere else the tool will not
 * load the text and initialize your sketch correctly.<br/>
 * The error will be notified to you in the P5's console and
 * message area.</p>
 * 
 * @version 0.2
 *
 * @author Jonathan Acosta (aka 0p0)
 *
 * @see getMenuTitle()
 * @see init(Editor ed)
 * @see run()
 */
public class InitSketchFromTemplate implements Tool {

    // FIELDS:
    /**
     * Contains the template text read from the template file.
     * This field is inserted in the Processing Editor pane.
     */
    private String templateString = "";
    /** 
     * Contains the template's absolute path for console display.
     */
    private String templatePath;
    /**
     * Contains the system's <i>file.separator</i> character property.
     */
    private String fileSep;
    /**
     * Iterates an <i>Editor</i> object.
     */
    private Editor editor;
    /**
     * The <i>FileInputStream</i> to read from the template file.
     */
    private FileInputStream fileIS;
    /**
     * Stores one byte at a time when reading from the template file.
     * This buffer is then cast as <i>char</i> type
     * into the <i>templateString</i> variable.
     */
    private int byteBuffer = 0;



    // MEMBERS:

    /**
     * <p>Required by the <i>Tool</i> interface.</p>
     * <p>Sets the menu item string for P5's menu bar.</p>
     * @return String
     */
    public String getMenuTitle() {
        return "Initialize from 'template.txt'";
    }

    /**
     * <p>Required by the <i>Tool</i> interface.</p>
     * <p>Initializes the Editor object in oprder to access
     * P5's text editor.</p>
     *
     * @param ed
     */
    public void init(Editor ed) {
        this.editor = ed;
    }

    /**
     * <p>Required by the <i>Tool</i> interface.</p>
     * <p>Runs the actual tool code. The process is as follows:</p>
     * <p><i>There is an attemp to load the "template.txt" file,
     * after corect loading every byte is read from the file
     * and cast as a char type to be added at the end of the
     * templateString variable, when the end fo the file is reached
     * rading the bytes stops and the string is inserted in the
     * editor area of P5's active window. After this process is done
     * the Objects fin and templateString are initialized back to 0.</i></p>
     * <p>In pseudocode the process looks like this:</p>
     * <blockquote><p><i>Try to open the file.<br/>
     * ----Iterate through each byte in the file:<br/>
     * --------Try to convert each byte to a char and add it to the end of templateString var.<br/>
     * --------If an error occurs when reading a byte, jump to the next iteration.<br/>
     * ----repeat while the end of file is not reached.<br/>
     * If the file load fails report the failure in the P5 console.<br/><br/>
     * If the length of templateString is bigger than 0 insert the contents of templateString in the editor, and inform of successfull insertion.<br/>
     * Else: inform of inability to initialize and jump to the end of the program.<br/><br/>
     * Try to shut down the FileInputStream.<br/>
     * Initialize templateString to 0 to be able to reuse it again in the same editing session.</i></p></blockquote>
     */
    public void run() {
        /*
         * To make this tool really cross-platform
         * we have first to find the System's default
         * file.separator property in order to make sure
         * the template search will be compatible with
         * the system's default values.
         */
        fileSep = System.getProperty("file.separator");


        /*
         * This block of code will try to find it inside the tool's
         * folder, right next to the executable .jar file of the tool.
         */
        try {
            /*
             * Passing the root and the rest of the
             * template path to the FileInputStream,
             * The System's default file.separator is
             * used in the path given to constructor calls.
             * Additionally, the path is stored in templatePath
             * for later use.
             */
            fileIS = new FileInputStream(
                    templatePath = Base.getSketchbookFolder()
                    + fileSep
                    + "tools"
                    + fileSep
                    + "InitSketchFromTemplate"
                    + fileSep
                    + "tool"
                    + fileSep
                    + "template.txt");
        } catch (FileNotFoundException e) { // If the template file is not found
            e.printStackTrace(); // Print the built-in Java error message.

            // And also this custom error message:
            System.err.println(
                    "Could not find the default template file!!!");
            System.out.println(
                    "Create a file named 'template.txt' "
                    + "and put it inside the " + templatePath
                    + " in order to be able to use this tool");
            fileIS = null;
        }


        /*
         * The byte-by-byte reading of the "fin" Object will
         * happen only if the file was found and loaded.
         */
        if (fileIS != null) {

            /*
             * A loop to read every byte from the
             * "template.txt" file, convert it to
             * a char and add it to the end of the
             * templateString until EOF is reached.
             */
            do {
                try {
                    byteBuffer = fileIS.read();
                    if (byteBuffer != -1) { // if EOF not reached:
						/*
                         * Store every new byte as a char
                         * at the end of templateString.
                         */
                        templateString += (char) byteBuffer;
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    continue;
                }

            } while (byteBuffer != -1); // The process is repeated until EOF is reached
        } else {
            editor.statusError(
                    "The template file was not found.");
        }



        /*
         * Enters the text read from the "template.txt"
         * file in the editor window but only if there
         * is something inside of the templateString "buffer".
         */
        if (templateString != null) {
            // Insert the contents of templateString inside the editor:
            editor.insertText(templateString);
            // Notify of completion of the initialization:
            editor.statusNotice(
                    "The sketch was initialized. To work! :D");
            System.out.println(
                    ">>> InitSketchFromTemplate version 0.2:");
            System.out.print(
                    "The sketch was successfully initialized from the contents of: ");
            System.out.println(templatePath);
        } else {
            editor.statusError(
                    "Template file was not found!");
        }


        /*
         * After inserting the template text in the Editor
         * the FileInputStream is closed if it contains something...
         */
        if (fileIS != null) {
            try {
                fileIS.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        /* ... and the templateString buffer is reset to length 0.
         * *** Without this last command the tool cannot be used
         * again properly in the same coding/editing session.***
         */
        templateString = "";
    }
}

