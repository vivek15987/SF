public with sharing class LRO {

    private String AWSCredentialName = 'S3 Integration';
    public S3.AmazonS3 as3;
    public S3.ListBucketResult objectsForBucket ;
    
    public LRO() { 
        try{
			
			AWSKeys credentials = new AWSKeys(AWSCredentialName);
			as3 = new S3.AmazonS3(credentials.key,credentials.secret);
			as3 = new S3.AmazonS3();
	    	as3.secret = credentials.secret;
			as3.key = credentials.key;
			
		}catch(AWSKeys.AWSKeysException AWSEx){
		     
		     ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.FATAL, AWSEx.getMessage());
			 ApexPages.addMessage(errorMsg);
			    
		}
    }
    
    public void PullLROFeeds() { 
        
        List<String> objectNames = new List<String>();
        Datetime now = Datetime.now();
        String BucketName = NULL;       
        Integer maxNumberToList = 25;
        String Prefix = null;
        String Marker = null;
        String Delimiter = null;
        
        
        S3.ListAllMyBucketsEntry[] buckets = as3.ListAllMyBuckets(as3.key,now,as3.signature('ListAllMyBuckets',now)).Buckets.Bucket;
        
        for(S3.ListAllMyBucketsEntry bucket: buckets){                 
            if( (' ' + bucket.Name).trim() == 'lro-updates' ){
                BucketName = (' ' + bucket.Name).trim();
                break;
            }           
        }
        
        System.debug('BucketName ' + BucketName);
        
        if ( BucketName != NULL) {
            
            objectsForBucket = as3.ListBucket(BucketName, Prefix, Marker ,maxNumberToList,Delimiter,as3.key,now,as3.signature('ListBucket',now),as3.secret);
            
           if ( objectsForBucket != null && objectsForBucket.Contents != null) {            
                for (S3.ListEntry f : objectsForBucket.Contents ) {
                    objectNames.add((' ' + f.Key).trim());
                }
           }
        }
        
        
        
        System.debug(objectNames);
        
        String filename = 'Laramar/7376_20150309.LRO';
        System.debug('redirectToS3Key filename: ' + filename);
      
        Datetime expireson = now.AddSeconds(120);
        Long Lexpires = expireson.getTime()/1000;
        
        System.debug('key: ' + as3.key);
        System.debug('secret: ' + as3.secret);
        //String codedFilename=  EncodingUtil.urlEncode(filename,'UTF-8');
       // System.debug('codedFilename: '+codedFilename); 
        String stringtosign = 'GET\n\n\n'+Lexpires+'\n/'+BucketName+'/'+filename;
        System.debug('redirectToS3Key stringstosign: ' + stringtosign);
        String signed = make_sig(stringtosign);
        System.debug('signed: ' + signed);
        String codedsigned = EncodingUtil.urlEncode(signed,'UTF-8');
        System.debug('codedsigned: ' + codedsigned);
        String url = 'http://'+BucketName+'.s3.amazonaws.com/'+filename+'?AWSAccessKeyId='+as3.key+'&Expires='+Lexpires+'&Signature='+signed;
        
        Http httpPro = new Http();
        HttpRequest request = new HttpRequest();
        String BodyContent = url;
        request.setEndPoint('http://lro-updates.s3.amazonaws.com');
        // request.setEndpoint('https://s3.amazonaws.com/soap');       
	        
	    
        request.setMethod( 'POST' );
        request.setHeader('Content-Type', 'application/soap+xml' );
	        request.setHeader('SOAPAction','');
        request.setBody( BodyContent );
        request.setHeader('Content-Length', '100'); 
        request.setTimeout( 120000 );
        
        HTTPResponse res = httpPro.send(request);
        String strMarketing4_0 = res.getBody(); 
        System.debug('response : ' + strMarketing4_0);
        //PageReference newPage = new PageReference(url);
     
        
      //  System.debug( newPage.getContent().toString() );
       // System.debug('newPage url: ' + newPage.getUrl());
        
    }
    
      private String make_sig(string canonicalBuffer) {        
        String macUrl ;
        String signingKey = EncodingUtil.base64Encode(Blob.valueOf(as3.secret));
        Blob mac = Crypto.generateMac('HMacSHA1', blob.valueof(canonicalBuffer),blob.valueof(as3.secret)); 
        macUrl = EncodingUtil.base64Encode(mac);                
        return macUrl;
    }
}