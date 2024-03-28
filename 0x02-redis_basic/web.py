import requests
import redis
import time

# Connect to Redis
redis_client = redis.StrictRedis(host='localhost', port=6379, db=0)

def get_page(url: str) -> str:
    # Check if the URL has been accessed before
    url_key = f"count:{url}"
    count = redis_client.get(url_key)
    if count:
        # If accessed before, increment the count
        redis_client.incr(url_key)
    else:
        # If not accessed before, set count to 1
        redis_client.set(url_key, 1, ex=10)  # Cache for 10 seconds

    # Check if the page is already cached
    html_content = redis_client.get(url)
    if not html_content:
        # If not cached, make an HTTP request
        response = requests.get(url)
        if response.status_code == 200:
            html_content = response.text
            # Cache the HTML content for 10 seconds
            redis_client.set(url, html_content, ex=10)

    return html_content

# Test the function
if __name__ == "__main__":
    url = "http://slowwly.robertomurray.co.uk"
    print(get_page(url))
    # Wait for 10 seconds
    time.sleep(10)
    # Access the URL again
    print(get_page(url))
