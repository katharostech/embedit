use serde::Deserialize;
use serde_json::json;

use warp::filters::query::query;
use warp::Filter;

#[macro_use]
extern crate lazy_static_include;
#[macro_use]
extern crate lazy_static;

lazy_static_include_str!(HTML_WRAPPER, "./wrapper.html");
lazy_static_include_str!(HTML_EMBED, "./video-embed.html");

#[derive(Debug, Deserialize)]
struct VideoQuery {
    video: String,
}

#[derive(Debug, Deserialize)]
struct OEmbedQuery {
    url: String,
    maxwidth: Option<i32>,
    maxheight: Option<i32>,
    format: Option<String>,
}

pub async fn run() {
    // Match any request and return hello world!
    let routes = warp::path("oembed.json")
        .and(query::<OEmbedQuery>())
        .map(|query_data: OEmbedQuery| {
            let embed = HTML_EMBED.replace("{video_url}", &query_data.url);

            warp::reply::json(&json!({
                "type": "video",
                "version": "1.0",
                "html": embed,
                // TODO: Definitely not standards complient
                "width": 500,
                "height": 500
            }))
        })
        .or(warp::get()
            .and(query::<VideoQuery>())
            .and(warp::header::<String>("host"))
            // Return an HTML page with the embedded video and the oembed representation
            // meta tag
            .map(|query_data: VideoQuery, host: String| {
                let embed = HTML_EMBED.replace("{video_url}", &query_data.video);
                warp::reply::html(
                    HTML_WRAPPER
                        // URL encode the video that will go into the head tag  for the oembed.json endpoint
                        .replace("{host}", &host)
                        .replace("{video_url}", &urlencoding::encode(&query_data.video))
                        .replace("{body}", &embed),
                )
            }));

    println!("Listening on 0.0.0.0:3030");
    warp::serve(routes).run(([0, 0, 0, 0], 3030)).await;
}
