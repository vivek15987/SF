@isTest
public class TestHBHPropertiesController {

    static testMethod void testHBHPullPropertiesController() {
        
        Account a = new Account();
        a.Name  = 'Test';
        insert a;

        Integration__c i           = new Integration__c();  
        i.Account__c             = a.Id;
        i.HBH_API_URL__c           = 'https://api.havenbrookhomes.com/api';
        i.Get_HBH_Properties__c        = 'Daily';
        i.HBH_Integration_Active__c     = true;
        insert i;

        Property__c p       = new Property__c();
        p.Account__c       = a.Id;
        p.HBH_Prop_Id__c     = '232b3f81-6625-e311-bfb2-0024e861de3d';
        p.Active__c 		= 'No';
        insert p;
        
        Grouping__c g = new Grouping__c(Name = 'Test',Account__c=a.id);
        insert g;

        Property__c p2      = new Property__c();
        p2.Account__c       = a.Id;
        p2.HBH_Prop_Id__c     = '232';
        insert p2;

        Test.startTest();
        
        HBHPullPropertiesController HBH = new HBHPullPropertiesController();
        HBH.responseJsonString = '[ { "property_id": "232b3f81-6625-e311-bfb2-0024e861de3d", "property_title": "4355 Donegal Circle", "property_type": "Single Family Home", "address_1": "4355 Donegal Circle", "city": "Lithia Springs", "state": "GA", "postal_code": "30122", "description": "Completely renovated, total electric three bedroom ranch! Features include hardwood flooring, spacious bedrooms plus a bonus room, plenty of closet space, laundry room, covered parking, and large yard.", "rent_per_month": 850, "approximate_square_feet": 1232, "bedroom_number": 3, "bathroom_number": 1, "neighborhood": null, "schools": [ "Lithia Springs Elementary School", "Turner Middle School", "Lithia Springs Comprehensive High School" ], "amenities_list": [ "Black Appliances", "Carport", "Fenced Yard", "Formal Dining Room", "Formal Living Room", "Front Porch", "Master on Main", "Upstairs Laundry", "Walk in Closet in Master" ], "top_features_list": [ "Beautiful Kitchen", "Cozy Den", "Hardwood Flooring", "Spacious Rooms", "Fenced Yard" ], "image_url_list": [ { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_front_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_front_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_living room_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_living room_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_kitchen v1_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_kitchen v1_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_dining area_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_dining area_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bedroom 3_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bedroom 3_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bedroom 2_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bedroom 2_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bedroom 1_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bedroom 1_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bathroom 1 v2_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_bathroom 1 v2_large.jpg" }, { "description": null, "thumbnail_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_back_thumb.jpg", "zoom_url": "http://devapi.havenbrookhomes.com:80/documents/232b3f81-6625-e311-bfb2-0024e861de3d/4355DonegalCir_back_large.jpg" } ], "latitude": 33.786045, "longitude": -84.68171, "DA": 164, "metro_area_id": "ATL", "open_house": [], "is_pending": false, "owned_property_id": "GA34971", "year_built": 1968, "field_office": "Northwest Atlanta", "property_manager_name": "", "property_manager_email": "", "property_manager_phone": "", "leasing_agent_name": "", "leasing_agent_email": "", "leasing_agent_phone": "", "property_status": "Available", "available_date": "2015-04-10T00:00:00", "make_ready_date": "2015-01-29T00:00:00", "pets_allowed": true, "pet_policy": "Limit of 2 domestic animals - cats, dogs or small caged animals.", "pet_deposit": "$250 per pet; non-refundable", "breed_restrictions": "Any pet considered to be of a violent breed such as a Pit Bull or with a history of violent behavior may be prohibited.", "minimum_lease_terms": "12 months", "minimim_lease_terms_mo": 12, "credit_check_required": true, "criminal_check_required": true, "rental_history_required": true, "renter_insurance_required": true, "app_fee_individual": 50, "app_fee_joint": 30, "std_security_deposit": "Based on credit score. Between 1 and 3 times monthly rent." } ]';
        HBH.HBHGetProperties( i.HBH_API_URL__c );
        
        System.schedule( 'HBHPullPropertiesScheduler', '00 01 12 14 1 ?', new HBHPullPropertiesScheduler( 5 ) );
        HBHPullPropertiesScheduler scheduler = new HBHPullPropertiesScheduler( 5 );
        scheduler = new HBHPullPropertiesScheduler();
        
        HBHPullPropertiesBatch objBatch = new HBHPullPropertiesBatch( );
        objBatch.HBHPullProperties = HBH;
        Database.executeBatch( objBatch, 5);
        
        Test.stopTest();

    }
}