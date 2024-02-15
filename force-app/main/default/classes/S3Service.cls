public with sharing class S3Service {
    public S3Service() {

    }

    Public Attachment myfile;
    Public Attachment getmyfile()
    {
        myfile = new Attachment();
        return myfile;
    }

    @AuraEnabled
    public static void createObjectInS3(String base64, String filename) {
        AWS.S3.PutObjectRequest request = new AWS.S3.PutObjectRequest();

        request.url = request.url + '/jonsnowbucket3421/'+filename;
        request.contentType = 'image/jpeg';
        // request.body = EncodingUtil.base64Decode(base64);
        request.body = EncodingUtil.base64Decode('');
        AWS.S3.PutObjectResponse response = new AWS.S3.PutObject().call(request);
        System.debug('request: ' + request.url);
        System.debug('response: ' + response);
    }

    public void getObjectInSystem() {
        AWS.S3.GetObjectRequest request = new AWS.S3.GetObjectRequest();
        request.url = 'https://s3.us-east-1.amazonaws.com/jonsnowbucket3421/key.xml';
        AWS.S3.GetObjectResponse response = new AWS.S3.GetObject().call(request);
        System.debug(response.body); // 'test_body'
    }

    public void createBucketInS3() {
        AWS.S3.CreateBucketRequest request = new AWS.S3.CreateBucketRequest();
        System.debug('request: ' + request);
        request.url = 'https://s3.us-east-1.amazonaws.com/jonsnowbucket3421';
        AWS.S3.CreateBucketResponse response = new AWS.S3.CreateBucket().call(request);
    }

    public void getListOfData() {
        AWS.S3.ListObjectsRequest request = new AWS.S3.ListObjectsRequest();
        request.url = 'https://s3.us-east-1.amazonaws.com/jonsnowbucket3421';
        AWS.S3.ListObjectsResponse response = new AWS.S3.ListObjects().call(request);
        System.debug('response: ' + response);
    }

    @AuraEnabled (cacheable=true)
    public static AWS_Config__c getS3ConfigSettings(){
        return AWS_Config__c.getOrgDefaults();
    }
}