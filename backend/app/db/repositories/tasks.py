"""Domain Repository for 'task' entity.

All logic related to the task entity is defined and grouped here.
"""

from typing import List
import datetime as dt
import uuid

from loguru import logger
from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.db.models.tasks import Task as TaskModel
from app.api.schemas.tasks import TaskCreate, TaskUpdate
from app.api.filters.tasks import TaskFilter

from app.db.repositories.base import SQLAlchemyRepository


class TasksRepository(SQLAlchemyRepository):
    """Handle all logic related to Task entity.

    Inheritence from 'SQLAlchemyRepository' allows for crudl functionality.
    """

    label = "task"

    sqla_model = TaskModel

    create_schema = TaskCreate
    update_schema = TaskUpdate
    filter_schema = TaskFilter

    async def read_task_with_sub_tasks(
        self,
        id: uuid.UUID,
    ) -> TaskModel | None:
        """Read task with their subtasks by id."""
        # TODO: This may not filter out the "deleted" `sub_tasks``
        query = select(self.sqla_model, id).options(
            selectinload(self.sqla_model.sub_tasks)
        )
        result = await self.db.execute(query)

        if not result:
            raise self.not_found_error(id, "read with sub_tasks")

        return result.scalars().first()

    async def delete_and_update_sub_tasks(
        self,
        id: uuid.UUID,
        delete_sub_tasks: bool = False,
    ) -> TaskModel | None:
        """Update `deleted_at` for task.

        Then null `parent_id` or update `deleted_at` for any subtask.
        """
        query = select(self.sqla_model, id).options(
            selectinload(self.sqla_model.sub_tasks)
        )
        result = await self.db.execute(query)

        if not result:
            raise self.not_found_error(id, "delete")

        result.deleted_at = dt.datetime.now()

        for sub_task in result.sub_tasks:
            if delete_sub_tasks:
                sub_task.deleted_at = dt.datetime.now()
            else:
                sub_task.parent_id = None

        await self.db.commit()

        # TODO: check if result in string broke once converting to f-string
        logger.success(
            f"{self.capitalized_label}: {result} successfully deleted from database."
        )

        return result

    async def list_tasks_with_sub_tasks(
        self,
        list_filter: filter_schema,
    ) -> List[sqla_model] | None:
        """List all tasts with their sub-tasks."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.sub_tasks))
        query = list_filter.filter(query)
        query = list_filter.sort(query)
        results = await self.db.execute(query)
        return results.scalars().all()
