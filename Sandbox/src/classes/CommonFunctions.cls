public class CommonFunctions {
    
    public String RemovingSpecialCharacters(String str){      
      
         str = str.replaceAll('&', ' AND ');
         str = str.replaceAll('/', ' OR ');
         str = str.replaceAll('#', ' ');   
         str = str.replaceAll('\'s', 's');   
         system.debug('String is:' +str);
        return str;
    }
    
    public string StringToTimeConversion( String strDate, String strTime ) {
        
        if( strDate.length() > 1 && strTime.length() > 1 ) {
            List<String>ListDate 	= strDate.split( '-' );
            List<String>ListTime 	= strTime.Substring( 0, strTime.length()-5 ).split( ':' );
            String Year 			= String.valueOf( ListDate.get(0) );
            String Month 			= String.valueOf( ListDate.get(1) );
            String Day 				= String.valueOf( ListDate.get(2) );
            String Hour 			= String.valueOf( ListTime.get(0) );
            String Min 				= String.valueOf( ListTime.get(1) );
            
            if( strTime.contains( 'p' ) ) {
                Integer IntHour 			= Integer.valueOf( ListTime.get(0) );
                IntHour += 12;
                return( Year + '-' + Month + '-' + Day + 'T' + IntHour + ':' + Min + ':00' );
            } else{
                if( Hour.Length()==1 ) 
                    Hour = '0' + Hour;
                
                return( Year + '-' + Month + '-' + Day + 'T' + Hour + ':' + Min + ':00' );    
            }
        }
        return null;
    }
}