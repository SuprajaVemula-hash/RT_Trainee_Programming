@isTest
global class mockgetdata implements HttpCalloutMock {
    // Implementing the respond method to mock the HTTP response
    global HttpResponse respond(HttpRequest req) {
        // Create a fake HTTP response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        
        // Mock response body (replace with a realistic response structure from the API)
        String mockResponseBody = '[{"name":"John Doe","email":"john.doe@example.com","phone":"123-456-7890","status":"active"},'
                                + '{"name":"Jane Smith","email":"jane.smith@example.com","phone":"987-654-3210","status":"inactive"}]';
        
        res.setBody(mockResponseBody);
        return res;
    }
}
