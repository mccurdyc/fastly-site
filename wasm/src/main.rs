use fastly::http::{header, Method, StatusCode};
use fastly::{mime, Error, Request, Response};

use serde::{Deserialize, Serialize};
use url::Url;

#[derive(Debug, Serialize, Deserialize)]
struct BackendResponse {
    #[serde(rename(deserialize = "items"))]
    images: Vec<Image>,
}

#[derive(Debug, Serialize, Deserialize)]
struct Image {
    name: String,
    #[serde(rename(deserialize = "mediaLink"))]
    media_link: String,
}

#[derive(Debug, Deserialize)]
struct RequestData {
    bucket: String,
    prefix: String,
}

#[fastly::main]
fn main(mut req: Request) -> Result<Response, Error> {
    // Filter request methods...
    match req.get_method() {
        // Allow GET and HEAD requests.
        &Method::GET | &Method::HEAD => (),

        // Deny anything else.
        _ => {
            return Ok(Response::from_status(StatusCode::METHOD_NOT_ALLOWED)
                .with_header(header::ALLOW, "GET, HEAD")
                .with_body_text_plain("This method is not allowed\n"))
        }
    };

    // Pattern match on the path...
    match req.get_path() {
        "/" => Ok(Response::from_status(StatusCode::OK)
            .with_content_type(mime::TEXT_HTML_UTF_8)
            .with_body("Welcome to wasm.mccurdyc.dev!")),

        "/images/" => {
            let req_body = req.take_body_json::<RequestData>().unwrap();
            println!("req_body => {:?}", req_body);
            let mut url = Url::parse(&format!(
                "https://storage.googleapis.com/storage/v1/b/{}/o",
                req_body.bucket
            ))?;
            url.set_query(Some(&format!("prefix={}", req_body.prefix)));
            let mut be_resp = Request::get(url).send("gcs")?;
            println!("be_resp => {:?}", be_resp);

            let my_data = be_resp.take_body_json::<BackendResponse>()?;
            println!("my_data => {:?}", my_data);

            let mut resp = Response::new();
            resp.set_body_json(&my_data)?;
            Ok(resp)
        }

        // Catch all other requests and return a 404.
        _ => Ok(Response::from_status(StatusCode::NOT_FOUND)
            .with_body_text_plain("The page you requested could not be found\n")),
    }
}
