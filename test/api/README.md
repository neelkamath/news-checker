# Values

`test/values.dart` contains values for things like the DB connection info. 

# Testing the `check` API endpoint

Simply create a JSON in the `test/api/responses` directory (subdirectories such as `test/api/responses/reddit/fake_news` can also be created and used) file with the contents in the below format. 
```
{
  "request": "<REQUEST>",
  "response": <RESPONSE>
}
```
Replace `<REQUEST>` with the query you sent in the HTTP GET request to the server (e.g., `Donald Trump has a brain`).
Replace `<RESPONSE>` with the response you got from the server. 
