""" app.py """
from os import getenv
import logging

LOGGER = logging.getLogger(__name__)
LOGGER.propagate = True
LOGGER.setLevel(level=getenv("LOG_LEVEL", "DEBUG"))


def handler(event, context):
    """

    :param event:
    :param context:
    :return:
    """
    LOGGER.info(f"Event: {event}")

    return event