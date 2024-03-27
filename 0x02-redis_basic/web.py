#!/usr/bin/env python3
"""A module with tools for request caching and tracking."""
import requests
from functools import wraps
from typing import Callable


def data_cacher(method: Callable) -> Callable:
    """Caches the output of fetched data."""
    @wraps(method)
    def invoker(url: str) -> str:
        """The wrapper function for caching the output."""
        count_key = f'count:{url}'
        result_key = f'result:{url}'
        redis_store.incr(count_key)
        result = redis_store.get(result_key)
        if result:
            return result.decode('utf-8')
        result = method(url)
        redis_store.setex(result_key, 10, result)
        return result
    return invoker


@data_cacher
def get_page(url: str) -> str:
    """Returns the content of a URL after caching the request's response,
    and tracking the request.
    """
    return requests.get(url).text
