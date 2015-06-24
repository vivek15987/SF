public class YardiGCAgentsSourcesResponseController {

    public Map<String, Map<String, Map<String, Set<String>>>> AccuountAgents 		= new Map<String, Map<String, Map<String, Set<String>>>>();
    public Map<String, Map<String, Set<String>>> AgentSources 						= new Map<String, Map<String, Set<String>>>();
    public Set<String> AgentNames 													= new Set<String>();
    public Set<String> SourceNames 													= new Set<String>();
    public Set<String> Results 														= new Set<String>();
    public String PropertyCode;
    
    public Map<String, Map<String, Set<String>>> ParseAgentSourcesXML( XmlStreamReader reader ) {

        String AgentName;
        String SourceName;
        String Result;
        Boolean isSafeToGetNextXmlElement = true;
       

        while(isSafeToGetNextXmlElement) {               
           	if (reader.getEventType() == XmlTag.START_ELEMENT) {  
               	String strElementName = reader.getLocalName();
               	if ( 'AgentName' == strElementName || 'SourceName' == strElementName || 'Result' == strElementName || 'PropertyCode' == strElementName ) {
                   
                    if( 'PropertyCode' == strElementName ) {
                        PropertyCode = stringXMLElement(reader);
                    }
                    
                    if( 'AgentName' == strElementName ) {
                        AgentName = stringXMLElement(reader);
                        AgentNames.add(AgentName);
                    }
                    
                     if( 'SourceName' == strElementName ) {
                         SourceName = stringXMLElement(reader);
                         SourceNames.add(SourceName);
                    }
                    
                     if( 'Result' == strElementName ) {
                         Result = stringXMLElement(reader);
                         Results.add(Result);
                    }

                    
                    Map<String, Set<String>> AgentDetails = new Map<String, Set<String>>();
                    AgentDetails.put( 'AgentNames', AgentNames);
                    AgentDetails.put( 'SourceNames', SourceNames);
                    AgentDetails.put( 'Results', Results);
                    
                    AgentSources.put(PropertyCode, AgentDetails);
                    
                   // AccuountAgents.put( AccountId, AgentSources );

                }
            }
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement = false;
                break;
            }
        }

        //System.debug( AgentSources );
        return AgentSources;
       // System.debug( AgentSources );
    }
    
    public String stringXMLElement( XmlStreamReader reader ){
        
        String XMLElementValue;
        boolean isSafeToGetNextXmlElement1 = true;
                   
        while(isSafeToGetNextXmlElement1) {
            
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
                break;
            } else if (reader.getEventType() == XmlTag.CHARACTERS) {
                XMLElementValue = reader.getText();                           	
            }
            
            if (reader.hasNext()) {
                reader.next();
            } else {
                isSafeToGetNextXmlElement1 = false; 
                break;
            }
        }    
        return XMLElementValue;
    }

}