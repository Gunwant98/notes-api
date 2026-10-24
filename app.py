from flask import Flask, Response, jsonify, request
from prometheus_client import CONTENT_TYPE_LATEST, Counter, generate_latest

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "notes_api_http_requests",
    "Number of HTTP requests handled by the Notes API",
    ["method", "endpoint", "status"],
)


@app.after_request
def record_request(response):
    # Count app requests, but don't count Prometheus scraping /metrics.
    if request.endpoint != "metrics":
        REQUEST_COUNT.labels(
            request.method,
            request.endpoint or "unknown",
            str(response.status_code),
        ).inc()

    return response


@app.get("/health")
def health():
    return jsonify(status="ok")


@app.get("/metrics")
def metrics():
    return Response(
        generate_latest(),
        content_type=CONTENT_TYPE_LATEST,
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)