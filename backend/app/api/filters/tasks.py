import datetime as dt
import uuid

from fastapi_filter.contrib.sqlalchemy import Filter

from backend.app.db.models.tasks import Task

from .base import BaseFilter


class TaskFilter(BaseFilter):
    due_date: dt.date | None = None
    due_date__gte: dt.date | None = None
    due_date__lte: dt.date | None = None
    is_completed: bool | None = None
    parent_id: uuid.UUID | None = None
    parent_id__isnull: bool | None = False

    order_by: list[str] = ["-due_date"]  # What is due soonest
    search: str | None = None

    class Constants(Filter.Constants):
        model = Task
        search_model_fields = ["title", "description"]
