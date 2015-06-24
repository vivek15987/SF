public class YardiSRController {
    public String InterfaceLicense = 'MIIBEAYJKwYBBAGCN1gDoIIBATCB/gYKKwYBBAGCN1gDAaCB7zCB7AIDAgABAgJoAQICAIAEAAQQ04kJy30X+WrcKmOG31fsGQSByJyBaN/9ikl0g7XdZDNgCrbl3Ro04OmsmmmwjPqQLIBw+NuOo6uCkZBUqqstseBUmGs22iXQDMC8k3bHgpsChnW7Rlx1IGvmrV1UnlicraifDLti+vKzlKku0yf9G7RcZb7ecr16sCPIPutxcgXMnyQ57CQXPI+Zj2SQgiePNO5ERQ7jitCQu51KlvNtDN/pQ7XH3cKTdXAYQDwRM8jElXP3qf55mxPGLqdWFARQNECPWcG+W0ob1T+ZX2abJLVAnPQdOaMQvU0E';
    
    Public Set<ID> ServiceRequestIds  	= new Set<ID>();
    Public Map<String, Map<String, String>> AllIntegrationCredentials = new Map<String, Map<String, String>>();
    
    Public List<Service_Request1__c> arrobjServiceRequests = new List<Service_Request1__c>();
    Public List<Service_Request1__c> arrobjfetchedServiceRequests = new List<Service_Request1__c>();
    
    public YardiSRController() {}
    
    public void pushServiceRequests() {
        if( !ServiceRequestIds.isEmpty() ) {
            arrobjfetchedServiceRequests = [ SELECT 
                                            Id, Name, Cust_Unit_ID__c, Status__c, Account_Name__r.Id, Case_Origin__c, Service_Request_Type__r.Name, Repair_Sub_Category__c, Request_Category__c,
                                            Permission_to_Enter__c, Entry_Notes__c, Work_Order_Notes__c, Contact_Name__r.FirstName, Contact_Name__r.LastName, Contact_Phone__c, Contact_Mobile__c,
                                            Contact_Email__c, Create_Date__c, Final_Request_Disposition__c, Cust_Prop_ID__c, Customer_Work_Order_ID__c, Unit_Name__c, Source__c, Grouping__c, Address_Line_1__c,
                                            Address_Line_2__c, Unit_Needing_Service__r.Unit_ID__c
                                            FROM 
                                            Service_Request1__c
                                            WHERE
                                            Id IN :ServiceRequestIds
                                           ];
            
            if( !arrobjfetchedServiceRequests.isEmpty() ) {
                for( Service_Request1__c ServiceRequest : arrobjfetchedServiceRequests ) {
                    try{
                        Map<String, String> IntegrationCredentials = new Map<String, String>();
                        
                        if( null != ServiceRequest.Grouping__c && AllIntegrationCredentials.containsKey( ServiceRequest.Grouping__c ) ) {
                            IntegrationCredentials.putAll(AllIntegrationCredentials.get( ServiceRequest.Grouping__c ) );
                        } else if( null != ServiceRequest.Account_Name__r.Id ) {
                            IntegrationCredentials.putAll(AllIntegrationCredentials.get( ServiceRequest.Account_Name__r.Id ) );
                        }
                        System.debug( IntegrationCredentials.get( 'StandardClassification' ) );
                        if( !IntegrationCredentials.isEmpty() ) {
                            String ServiceResponseXML, SRXML;
                            
                            XmlStreamWriter writer = new XmlStreamWriter();
                            
                            writer.writeStartElement('', 'ServiceRequests', '');
                            writer.writeAttribute( '', '', 'xmlns', '');
                            writer.writeStartElement('', 'ServiceRequest', '');
                            writer.writeStartElement('', 'ServiceRequestId', '');
                            String YardiWorkOrderId = ( null != ServiceRequest.Customer_Work_Order_ID__c ) ? ServiceRequest.Customer_Work_Order_ID__c : '';
                            writer.writeCharacters(YardiWorkOrderId);
                            writer.writeEndElement();
                            
                            //Case_Origin__c
                            writer.writeStartElement('', 'Origin', '');
                            if( null != ServiceRequest.Case_Origin__c ) {
                                writer.writeCharacters(ServiceRequest.Case_Origin__c);
                            } else {
                                writer.writeCharacters('');
                            }             
                            writer.writeEndElement();
                            
                            //Cust_Prop_ID__c
                            writer.writeStartElement('', 'PropertyCode', 'xxxx');
                            if( null != ServiceRequest.Cust_Prop_ID__c ) {
                                writer.writeCharacters(ServiceRequest.Cust_Prop_ID__c);
                            } 
                            writer.writeEndElement();
                            
                            //Cust_Unit_ID__c            
                            writer.writeStartElement('', 'UnitCode', 'xxxx');
                            if( null != ServiceRequest.Cust_Unit_ID__c ) {
                                writer.writeCharacters(ServiceRequest.Cust_Unit_ID__c);
                            } else {
                                writer.writeCharacters('');
                            }              
                            writer.writeEndElement();
                            
                            //NULL
                            writer.writeStartElement('', 'TenantCode', 'xxxx');            
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            //NULL
                            writer.writeStartElement('', 'VendorCode', 'xxxx');
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            writer.writeStartElement('', 'ServiceRequestBriefDescription', 'xxxx'); 
                            if( null != ServiceRequest.Address_Line_1__c || null != ServiceRequest.Address_Line_2__c || null != ServiceRequest.Unit_Name__c ) {
                                String address = '';
                                if( null != ServiceRequest.Address_Line_1__c )
                                    address = ServiceRequest.Address_Line_1__c;
                                
                                if( null != ServiceRequest.Address_Line_2__c )
                                    address = address + ServiceRequest.Address_Line_2__c; 
                                
                                if( null != ServiceRequest.Unit_Name__c ){
                                    address = address + ServiceRequest.Unit_Name__c; 
                                }
                                
                                if( address.length() <= 34 )
                                    writer.writeCharacters( address );
                                else 
                                    writer.writeCharacters( address.substring(0,34) );
                            } else {
                                writer.writeCharacters('No Data for Address Information');
                            }  
                            
                            writer.writeEndElement();
                            
                            //Work_Order_Notes__c Need to check
                            writer.writeStartElement('', 'ServiceRequestFullDescription', '');
                            if( null != ServiceRequest.Work_Order_Notes__c ) {
                                if( ServiceRequest.Work_Order_Notes__c.length() <= 34 ){
                                    writer.writeCharacters(ServiceRequest.Work_Order_Notes__c);    
                                } else {
                                    String ServiceRequestBriefDescription = ServiceRequest.Work_Order_Notes__c.substring(0,34);
                                    writer.writeCharacters(ServiceRequestBriefDescription);    
                                }
                            } else {
                                writer.writeCharacters('No Data for Workorder Notes');
                            }           
                            writer.writeEndElement();
                            
                            String Priority = 'Emergency';    
                            writer.writeStartElement('', 'Priority', '');
                            if( null != ServiceRequest.Final_Request_Disposition__c ) {
                                if( 'Emergency' == ServiceRequest.Final_Request_Disposition__c && null != IntegrationCredentials.get('EmergencyClassification') ) {
                                    Priority = IntegrationCredentials.get('EmergencyClassification');
                                } else if( 'Standard' == ServiceRequest.Final_Request_Disposition__c ) {
                                    Priority = 'Standard';
                                    if( null != IntegrationCredentials.get('StandardClassification') ) {
                                        Priority = IntegrationCredentials.get('StandardClassification');
                                    } 
                                } 
                            }
                            
                            writer.writeCharacters(Priority);
                            writer.writeEndElement();
                            
                            //Request_Category__c
                            writer.writeStartElement('', 'Category', '');
                            if( null != ServiceRequest.Request_Category__c ) {
                                writer.writeCharacters(ServiceRequest.Request_Category__c);
                            } else {
                                writer.writeCharacters('Plumbing');
                            }
                            writer.writeEndElement();
                            
                            //Repair_Sub_Category__c
                            writer.writeStartElement('', 'SubCategory', '');
                            if( null != ServiceRequest.Repair_Sub_Category__c ) {
                                writer.writeCharacters(ServiceRequest.Repair_Sub_Category__c);
                            } else {
                                writer.writeCharacters('');
                            }            
                            writer.writeEndElement();
                            
                            //Permission_to_Enter__c
                            writer.writeStartElement('', 'HasPermissionToEnter', '');
                            if( null != ServiceRequest.Permission_to_Enter__c ) {
                                if( 'Yes' == ServiceRequest.Permission_to_Enter__c ) {
                                    writer.writeCharacters('True');
                                } else {
                                    writer.writeCharacters('False');
                                }
                            } else {
                                writer.writeCharacters('True');
                            }               
                            writer.writeEndElement();
                            
                            //Entry_Notes__c
                            writer.writeStartElement('', 'AccessNotes', '');
                            if( null != ServiceRequest.Entry_Notes__c ) {
                                writer.writeCharacters(ServiceRequest.Entry_Notes__c);
                            } else {
                                writer.writeCharacters('');
                            }             
                            writer.writeEndElement();
                            
                            //Work_Order_Notes__c
                            writer.writeStartElement('', 'ProblemDescriptionNotes', '');
                            if( null != ServiceRequest.Work_Order_Notes__c ) {
                                writer.writeCharacters(ServiceRequest.Work_Order_Notes__c);
                            } else {
                                writer.writeCharacters('');
                            }
                            writer.writeEndElement();
                            
                            writer.writeStartElement('', 'TechnicianNotes', '');
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            writer.writeStartElement('', 'TenantCaused', '');
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            writer.writeStartElement('', 'RequestorName', '');
                            if( null != ServiceRequest.Contact_Name__r.LastName ) {
                                if( null != ServiceRequest.Contact_Name__r.FirstName ) 
                                    writer.writeCharacters( ServiceRequest.Contact_Name__r.FirstName + ' ' + ServiceRequest.Contact_Name__r.LastName); 
                                else 
                                    writer.writeCharacters( ServiceRequest.Contact_Name__r.LastName);
                            } else {
                                writer.writeCharacters('');
                            }
                            writer.writeEndElement();
                            
                            //Contact_Phone__c
                            writer.writeStartElement('', 'RequestorPhoneNumber', '');
                            if( null != ServiceRequest.Contact_Phone__c ) {
                                writer.writeCharacters(ServiceRequest.Contact_Phone__c);
                            } else if( null != ServiceRequest.Contact_Mobile__c ) {
                                writer.writeCharacters(ServiceRequest.Contact_Mobile__c);
                            } else {
                                writer.writeCharacters('');
                            }
                            writer.writeEndElement(); 
                            
                            //Contact_Email__c
                            writer.writeStartElement('', 'RequestorEmail', '');
                            if( null != ServiceRequest.Contact_Email__c ) {
                                writer.writeCharacters(ServiceRequest.Contact_Email__c);
                            } else {
                                writer.writeCharacters('');
                            }
                            writer.writeEndElement();
                            
                            writer.writeStartElement( '', 'AuthorizedBy', '');
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            writer.writeStartElement('', 'CurrentStatus', '');
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            writer.writeStartElement('', 'Resolution', '');
                            writer.writeCharacters('');
                            writer.writeEndElement();
                            
                            writer.writeEndElement();
                            writer.writeEndElement();
                            SRXML = writer.getXmlString();
                            writer.close();                
                            
                            YardiSRWsdltoApexController.ItfServiceRequestsSoap yardiWsdltoApex = new YardiSRWsdltoApexController.ItfServiceRequestsSoap();  
                            YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element requstXML = new YardiSRWsdltoApexController.CreateOrEditServiceRequests_ServiceRequestXml_element();
                            
                            requstXML.anyElement = SRXML;
                            if( !Test.isRunningTest() ) {
                                ServiceResponseXML = yardiWsdltoApex.CreateOrEditServiceRequests_Http( IntegrationCredentials.get( 'UserName' ), IntegrationCredentials.get( 'Password' ), IntegrationCredentials.get( 'ServerName' ), IntegrationCredentials.get( 'Database' ), IntegrationCredentials.get( 'Platform' ), ServiceRequest.Cust_Prop_ID__c, IntegrationCredentials.get( 'VersionNumber' ), InterfaceLicense, requstXML, IntegrationCredentials.get( 'APIURL' ) );
                            } else {
                                ServiceResponseXML = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><soap:Body><CreateOrEditServiceRequestsResponse xmlns="http://tempuri.org/YSI.Interfaces.WebServices/ItfServiceRequests"><CreateOrEditServiceRequestsResult><ServiceRequests xmlns=""><ServiceRequest><ServiceRequestId>10825</ServiceRequestId><Origin>Em</Origin><PropertyCode>anyhome1</PropertyCode><ServiceRequestBriefDescription>sparkings</ServiceRequestBriefDescription><ServiceRequestFullDescription>sparking</ServiceRequestFullDescription><Priority>High</Priority><Category>Plumbing</Category><HasPermissionToEnter>true</HasPermissionToEnter><TenantCaused>false</TenantCaused><RequestorName>justin</RequestorName><ServiceRequestDate>2014-12-04</ServiceRequestDate><CreatedBy>Anyone Home-SR</CreatedBy><UpdateDate>2014-12-04T04:53:57</UpdateDate><UpdatedBy>Anyone Home-SR</UpdatedBy><CurrentStatus>Scheduled</CurrentStatus><StatusHistory><Status Type="Scheduled" TimeStamp="2014-12-04T04:53:57" /></StatusHistory><Resolution>Good</Resolution></ServiceRequest></ServiceRequests></CreateOrEditServiceRequestsResult></CreateOrEditServiceRequestsResponse></soap:Body></soap:Envelope>';
                                
                            }
                            
                            System.debug( 'ServiceResponseXML : ' + ServiceResponseXML );
                            
                            if( !String.isEmpty( ServiceResponseXML ) ) {
                                Dom.Document doc = new dom.Document();
                                doc.load(ServiceResponseXML);
                                YardiSRResponseController response = new YardiSRResponseController();
                                YardiSRResponseController.ServiceRequest ServiceRequestResponse = response.parseServiceRequestResponse(doc);  
                                
                                System.debug( 'Parsed ServiceResponse XML : ' + ServiceRequestResponse );
                                
                                if( true == ServiceRequestResponse.srIsFailed ){
                                    ServiceRequest.Integration_Failed__c = true;
                                    ServiceRequest.Work_Order_Entered_in_PMS__c = false;
                                    ServiceRequest.Integration_Fail_Success_Message__c = ServiceRequestResponse.srErrorMessage;
                                    ServiceRequest.Customer_Work_Order_ID__c = YardiWorkOrderId;
                                    
                                    System.debug( ' SF Id : ' + ServiceRequest.Id + ' Sync with yardi work order Id : ' + ServiceRequestResponse.srWorkOrderId + ' Error : ' + ServiceRequestResponse.srErrorMessage );
                                } else {
                                    ServiceRequest.Work_Order_Entered_in_PMS__c = true;
                                    ServiceRequest.Integration_Failed__c = false;
                                    ServiceRequest.Integration_Fail_Success_Message__c = 'SUCCESS';               
                                    ServiceRequest.Customer_Work_Order_ID__c = ServiceRequestResponse.srWorkOrderId;
                                    
                                    System.debug( ' SF Id : ' + ServiceRequest.Id + ' Sync with yardi work order Id : ' + ServiceRequestResponse.srWorkOrderId );
                                }  
                            } else {
                                ServiceRequest.Integration_Failed__c = true;
                                ServiceRequest.Work_Order_Entered_in_PMS__c = false;
                                ServiceRequest.Integration_Fail_Success_Message__c = 'Error: Response is empty';
                                ServiceRequest.Customer_Work_Order_ID__c = YardiWorkOrderId;
                                
                            }
                                                              
                            arrobjServiceRequests.add(ServiceRequest);       
                        }
                    } catch ( Exception e ) {
                        System.debug( e.getMessage() );
                        System.debug( e.getStackTraceString() );
                        System.debug( ServiceRequest.Id );
                    }
                }
            }
        }
    }
}