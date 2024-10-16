"""Endpoints for 'tasks' ressource."""

import uuid
from typing import List

from fastapi import APIRouter, Depends, status
from fastapi_filter import FilterDepends

from app.api.dependencies.repository import get_repository
from app.db.repositories.tasks import TasksRepository
from app.core.tags_metadata import tasks_tag

from ..schemas.tasks import TaskCreate, TaskInDB, TaskUpdate, TaskWithSubTasks
from ..filters.tasks import TaskFilter


router = APIRouter(prefix="/tasks", tags=[tasks_tag.name])


# Basic Task Endpoints
# =========================================================================== #
@router.post("/", response_model=TaskInDB, status_code=status.HTTP_201_CREATED)
async def create_task(
    task_new: TaskCreate,
    task_repo: TasksRepository = Depends(get_repository(TasksRepository)),
) -> TaskInDB:
    result = await task_repo.create(obj_new=task_new)
    return TaskInDB.model_validate(result)


@router.get("/{task_id}/", response_model=TaskWithSubTasks)
async def read_task(
    task_id: uuid.UUID,
    task_repo: TasksRepository = Depends(get_repository(TasksRepository)),
) -> TaskWithSubTasks:
    result = await task_repo.read_task_with_sub_tasks(id=task_id)
    return TaskWithSubTasks.model_validate(result)


@router.patch("/{task_id}/", response_model=TaskInDB)
async def update_task(
    task_id: uuid.UUID,
    task_update: TaskUpdate,
    task_repo: TasksRepository = Depends(get_repository(TasksRepository)),
) -> TaskInDB:
    result = await task_repo.update(id=task_id, obj_update=task_update)
    return TaskInDB.model_validate(result)


@router.delete("/{task_id}/", response_model=TaskInDB)
async def delete_task(
    task_id: uuid.UUID,
    delete_sub_tasks: bool = False,
    task_repo: TasksRepository = Depends(get_repository(TasksRepository)),
) -> TaskInDB:
    result = await task_repo.delete_and_update_sub_tasks(
        id=task_id, delete_sub_tasks=delete_sub_tasks
    )
    return TaskInDB.model_validate(result)


@router.get("/", response_model=List[TaskInDB])
async def list_tasks(
    task_filter=FilterDepends(TaskFilter),
    task_repo: TasksRepository = Depends(get_repository(TasksRepository)),
) -> List[TaskInDB]:
    result = await task_repo.filter_list(task_filter)
    return [TaskInDB.model_validate(task) for task in result]
