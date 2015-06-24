@isTest
global class HttpPSIPullFloorPlansResponse implements HttpCalloutMock {
    global HTTPResponse respond( HTTPRequest req ) {
        // Create a fake response.
        // Set response values, and 
        // return response.
        HttpResponse res = new HttpResponse();
        res.setStatus( 'OK' );
        res.setBody( '{ "response":{ "requestId": "15", "result":{ "FloorPlans":{ "FloorPlan":[ { "Identification":{ "@attributes":{ "IDRank":"primary", "IDScopeType":"sender", "IDType":"Floorplan ID" }, "IDValue":456789 }, "Name":"Floorplan 1", "UnitsAvailable":10, "Room":[ { "@attributes":{ "RoomType":"Bedroom" }, "Count":2 }, { "@attributes":{ "RoomType":"Bathroom" }, "Count":1 } ], "SquareFeet":{ "@attributes":{ "Max":900, "Min":900 } }, "MarketRent":{ "@attributes":{ "Max":850, "Min":850 } }, "Deposit":{ "@attributes":{ "DepositType":"security deposit" }, "Amount":{ "@attributes":{ "AmountType":"MonthMultiple" }, "ValueRange":{ "@attributes":{ "Min":250, "Max":250 } } } }, "Amenity":[ { "@attributes":{ "AmenityType":"AdditionalStorage" } }, { "@attributes":{ "AmenityType":"AirConditioner" } } ], "File":[ { "FileType":"Floorplan", "@attributes":{ "FileID":345678, "Active":"true" }, "Description":"2D Floor Plan", "Name":"Floorplan1.jpg", "Caption":"Floorplan1.jpg", "Format":"Jpg", "Width":"480", "Height":"640", "Src":"--MediaPath--" } ] } ] } } } }' );
        res.setStatusCode( 200 );
        return res;
    }
}