global class Pusher {
    public class PusherException extends Exception {
    }

    @future (callout=true)
    WebService static void push(String authKey, String authSecret, String appid, String channel, String name, String message) {
        String authTimestamp = String.valueOf(Datetime.now().getTime() / 1000);
        String authVersion = '1.0';
        String bodyMd5 = EncodingUtil.convertToHex(Crypto.generateDigest('MD5', 
          Blob.valueOf(message)));
        String path = '/apps/'+appid+'/channels/'+channel+'/events';

        String stringToSign = 'POST\n'+path+'\nauth_key='+authKey+
            '&auth_timestamp='+authTimestamp+'&auth_version='+authVersion+
            '&body_md5='+bodyMd5+'&name='+name;

        String authSignature =
            EncodingUtil.convertToHex(Crypto.generateMac('hmacSHA256',
              Blob.valueOf(stringToSign), Blob.valueOf(authSecret)));

        String endpoint = 'https://api.pusherapp.com'+path+
            '?auth_key='+authKey+
            '&auth_timestamp='+authTimestamp+
            '&auth_version='+authVersion+
            '&body_md5='+bodyMd5+
            '&name='+name+
            '&auth_signature='+authSignature;

        HttpRequest req = new HttpRequest(); 

        req.setMethod('POST');
        req.setEndpoint(endpoint);
        req.setBody(message); 
               
        HTTPResponse res = new HTTPResponse();
        if (!Test.isRunningTest()) {
            Http http = new Http();      
            res = http.send(req);    
            if (res.getStatusCode() != 202) {
                throw new PusherException(res.getStatusCode() + ' ' + res.getStatus());
            }
        }
    }
}