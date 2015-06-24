public class Test_Sampath {
    public void test(){
        
        XmlStreamWriter w = new XmlStreamWriter();
        w.writeStartDocument(null,'1.0');
        w.writeStartElement('','accounts','Test');
        w.writeStartElement(null,'accounts1',null);
        w.writeAttribute( '', '', 'xmlns', 'sampath');
        w.writeCharacters('anyhome1');
        w.writeEndElement();
        w.writeEndElement();
        w.writeEndDocument();
        string xml = w.getXmlString();
        w.close();
        system.debug(xml);
    }   
}