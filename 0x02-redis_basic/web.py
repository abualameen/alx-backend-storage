#!/usr/bin/env python3
"""A module for web-related functionalities."""
import requests
import redis
from functools import wraps
from typing import Callable

# Initialize Redis connection
redis_store = redis.Redis()


def track_and_cache(method: Callable) -> Callable:
    """Decorator to track URL access count and cache results."""
    @wraps(method)
    def wrapper(url: str) -> str:
        """Wrapper function to track and cache URL content."""
        count_key = f'count:{url}'
        result_key = f'result:{url}'
        
        # Increment access count
        redis_store.incr(count_key)
        
        # Check if result is cached
        result = redis_store.get(result_key)
        if result:
            return result.decode('utf-8')
        
        # Fetch content if not cached
        try:
            response = requests.get(url)
            response.raise_for_status()  # Raise an error for bad responses
            content = response.text
        except requests.exceptions.RequestException as e:
            print(f"Error fetching URL '{url}': {e}")
            return ""

        # Cache content with expiration time of 10 seconds
        redis_store.setex(result_key, 10, content)
        
        return content
    return wrapper


@track_and_cache
def get_page(url: str) -> str:
    """Fetches HTML content of a URL."""
    return requests.get(url).text


if __name__ == "__main__":
    # Example usage
    url = "http://slowwly.robertomurray.co.uk/delay/1000/url/http://example.com"
    print(get_page(url))
