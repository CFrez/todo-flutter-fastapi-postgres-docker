"""Domain Repository for 'task' entity.

All logic related to the task entity is defined and grouped here.
"""

from typing import List

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
        id,
    ) -> TaskModel | None:
        """Read task with their subtasks by id."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.sub_tasks))
        result = await self.db.execute(query)
        if not result:
            raise self.not_found_error(id, "read with sub_tasks")
        return result.scalars().first()

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
