"""Pydantic domain models for 'tasks' ressource."""

import datetime as dt
import uuid

from pydantic import ConfigDict

from .base import BaseSchema, IDSchemaMixin


class TaskBase(BaseSchema):
    """Base schema for 'task'."""

    title: str
    description: str | None = None
    due_date: dt.date | None = None
    is_completed: bool = False

    parent_id: uuid.UUID | None = None


class TaskInDB(TaskBase, IDSchemaMixin):
    """Schema for 'task' in database."""

    pass


class TaskCreate(TaskBase):
    """Schema for creating 'task' in database."""

    pass


class TaskUpdate(TaskBase):
    """Schema for updating 'task' in database.

    Updating only allowed for 'title', 'description', 'due_date', 'is_completed', 'parent_id' fields.
    All other fields will be ignored.
    """

    model_config = ConfigDict(extra="ignore")

    title: str | None = ...
    description: str | None = ...
    due_date: dt.date | None = ...
    is_completed: bool | None = ...
    parent_id: uuid.UUID | None = ...


class TaskWithSubTasks(TaskInDB):
    """Schema for 'task' with sub-tasks."""

    sub_tasks: list[TaskInDB] = []
