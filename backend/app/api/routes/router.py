"""Bundling of endpoint routers.

Import and add all endpoint routers here.
"""

from fastapi import APIRouter

from app.api.routes import tasks


router = APIRouter()

router.include_router(tasks.router)
