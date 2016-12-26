import java.io.FileInputStream;
import java.io.IOException;
import javax.print.Doc;
import javax.print.DocFlavor;
import javax.print.DocPrintJob;
import javax.print.PrintException;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.standard.Copies;
import javax.swing.JTextPane;

final static String TEMPORARYFILE_PREFIX = "frame2print";

void printText( String text2print ) {
  // code comes from: http://stackoverflow.com/questions/1097346/print-text-file-to-specific-printer-in-java
  boolean show = false; // set to true if you want to see the printer configuration popup
  JTextPane jtp = new JTextPane();
  jtp.setText( text2print );
  try {
    jtp.print(null, null, show, null, null, show);
  } 
  catch (java.awt.print.PrinterException ex) {
    println( "* printText ERROR *************" );
    ex.printStackTrace();
    println( "* printText ERROR *************" );
  }
}
boolean printFrame() {
  return printFrame( true );
}

boolean printFrame( boolean autodelete ) {
  // using a temp image and send it to the printer.
  // the temp image will be deleted at the end of the printing if autodelete is set to true
  String r = "" + ( (int) random( 0, 1000000 ));
  while( r.length() < 6 ) { r = "0"+r; }
  String tmpFramePath = dataPath("") + "/" + TEMPORARYFILE_PREFIX + "_" + frameCount + "_" + r + ".png";
  
  save( tmpFramePath );
  PImage ttmp = loadImage(tmpFramePath);

  PGraphics tt = createGraphics(width,height,P2D);
  
  tt.beginDraw();
  tt.background(255);
  tt.image(ttmp,-768/2+144/2,0);
  tt.endDraw();
  tt.filter(INVERT);

  tt.save(tmpFramePath);

  boolean success = printImage( tmpFramePath, false );
  if ( !success ) {
    return false;
  }
  if ( autodelete ) {
    try {
      File file = new File( tmpFramePath );
      if (file.delete()) {
        println( file.getName() + " is deleted!" );
      } else {
        System.out.println( file.getName() + " is not delete.");
      }
    } catch( Exception e ) {
      println( "* printCurrentFrame:delete ERROR *************" );
      e.printStackTrace();
      println( "* printCurrentFrame:delete ERROR *************" );
    }
  }
  return true;
}

boolean printImage( String imagepath ) {
  return printImage( imagepath, true );
}

boolean printImage( String imagepath, boolean indatafolder ) {
  // code comes from: http://www.java2s.com/Code/Java/2D-Graphics-GUI/PrintanImagetoprintdirectly.htm
  // it has been adapted to use data folder path
  try {
    PrintRequestAttributeSet pras = new HashPrintRequestAttributeSet();
    pras.add(new Copies(1));
    PrintService pss[] = PrintServiceLookup.lookupPrintServices(DocFlavor.INPUT_STREAM.GIF, pras);
    
    if (pss.length == 0)
      throw new RuntimeException("No printer services available.");
    
    PrintService ps = pss[0];
    System.out.println("Printing to " + ps);
    DocPrintJob job = ps.createPrintJob();
    String imgpath = imagepath;
    
if ( indatafolder ) {
      imgpath = dataPath("")+"/"+imagepath;
    }

    FileInputStream fin = new FileInputStream( imgpath );
    Doc doc = new SimpleDoc(fin, DocFlavor.INPUT_STREAM.GIF, null);
    job.print(doc, pras);
    fin.close();
    return true;
  } 
  catch( Exception e ) {
    println( "* printImage ERROR *************" );
    e.printStackTrace();
    println( "* printImage ERROR *************" );
  }
  return false;
}




