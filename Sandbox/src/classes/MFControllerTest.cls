@isTest
public class MFControllerTest {
    static testMethod void testMFController()
    {
        Test.startTest();
        Account a = new Account();
        a.name = 'Test Account';
        insert a;
        
        Sister_Property__c sp = new Sister_Property__c();
        sp.Name = 'New sister Property group';
        sp.Account__c = a.Id;
        insert sp;
        
        
        Zip_Code__c z = new Zip_Code__c();
        z.State__c = 'AK';
        z.Latitude__Latitude__s = 25.79;
        z.Latitude__Longitude__s = 25.79;
        z.Longitude__Longitude__s  = -80.13;
        z.Longitude__Latitude__s = -80.13;
        insert z; 
        
        geopointe__Geocode__c g1 = new geopointe__Geocode__c();
        g1.geopointe__Parent_Record_ID__c ='Mh002';
        g1.geopointe__Latitude__c =25.79;
        g1.geopointe__Longitude__c =-80.13; 
        insert g1;
        
        Property__c p = new Property__c();
        p.Account__c = a.Id;
        p.Zip_Code_Lookup__c = z.id;  
        p.Sister_Property__c = sp.Id;
        p.Geocode__c = g1.Id;
        insert p;
        
        geopointe__Geocode__c g2 = new geopointe__Geocode__c();
        g2.geopointe__Parent_Record_ID__c ='Mh003';
        g2.geopointe__Latitude__c =33.79;
        g2.geopointe__Longitude__c =-76.13;
        insert g2; 
        
        Property__c p1 = new Property__c();
        p1.Account__c = a.Id;
        p1.Zip_Code_Lookup__c = z.id; 
        p1.Sister_Property__c = sp.Id;
        p1.Geocode__c = g2.Id;
        insert p1;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;
        
        Floor_Plan__c fp = new Floor_Plan__c();
        fp.Account__c = a.Id;
        fp.Property__c = p.Id;
        fp.Active__c = true;
        fp.Is_Waitlist__c = false;
        insert fp;
        
        Floor_Plan__c fp2 = new Floor_Plan__c();
        fp2.Account__c = a.Id;
        fp2.Property__c = p.Id;
        fp2.Active__c = true; 
        fp2.Bedrooms__c = 5;
        fp2.Square_Feet__c = '600';
        fp2.Bathrooms__c = 2;
        insert fp2;
        
        
        List<Unit__c> units = new List<Unit__c>();
        
        for( Integer i = 0; i < 10 ; i++ ) {
            Unit__c unit = new Unit__c();
            if( (i / 2) == 0 ) {
                unit.Account__c = a.Id;
                unit.Property__c = p.Id;
                unit.Floor_Plan__c = fp2.Id; 
                unit.Active__c = true; 
                unit.Bedrooms__c = i;
                unit.Pets_Allowed__c = 'Yes';
                unit.Smoking_Allowed__c = 'Yes';
                unit.Special_Concession__c = '25% off';
                unit.Active__c = true;
            } else {
                unit.Account__c = a.Id;
                unit.Property__c = p.Id;
                unit.Floor_Plan__c = fp.Id; 
                unit.Active__c = true; 
                unit.Bedrooms__c = i;
                unit.Active__c = true;
                unit.Pets_Allowed__c = 'No';
                unit.Smoking_Allowed__c = 'No';
                unit.Special_Concession__c = 'abc';
            }
            units.add(unit);
        } 
        insert units; 
        
        
        MFController controller = new MFController();
        controller.myMethod(); 
        
        ApexPages.CurrentPage().getparameters().put('pid', p.id);        
        ApexPages.StandardController sc = new ApexPages.StandardController( p );
        MFController controller1 = new MFController(sc);
     
        MFController.dateRetrieval('2014-11-18');  
        MFController.getFloorplans(p.id);
        MFController.getRentRangeSilderVaules(p.Id, '2014-11-18');
        MFController.searchFloorPlansData('2014-11-18', p.Id, '1-2-3-4-5-6');
        MFController.searchFloorPlansData('2014-11-18', p.Id, '1-2-3-4');       
        MFController.searchUnitsData('2014-11-18', p.Id, '1-2-3-4', '',  fp.Id + '' );
        MFController.searchUnitsData('2014-11-18', p.Id, '1-2-3-4-5-6', '',  fp.Id + '' );
        MFController.searchUnitsData('2014-11-18', p.Id, '1-2-3-4', '', fp2.Id + '' );
        MFController.searchUnitsData('2014-11-18', p.Id, '1-2-3-4-5-6', '', 'All' );
        MFController.getSchools(p.Id);
        MFController.loadSisterProperties(sp.Id,p.Id, g1.geopointe__Latitude__c ,g1.geopointe__Longitude__c);
       
        Test.stopTest();
    }
}