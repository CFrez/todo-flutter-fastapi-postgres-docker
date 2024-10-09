"""Domain Repository for 'parent' entity.

All logic related to the parent entity is defined and grouped here.
"""

from typing import List

from sqlalchemy import select
from sqlalchemy.orm import selectinload

from app.db.models.tasks import Task as TaskModel
from app.api.schemas.tasks import TaskCreate, TaskUpdate
from app.api.filters.tasks import TaskFilter

from app.db.repositories.base import SQLAlchemyRepository


class ParentRepository(SQLAlchemyRepository):
    """Handle all logic related to Parent entity.

    Inheritence from 'SQLAlchemyRepository' allows for crudl functionality.
    """

    label = "parent"

    sqla_model = TaskModel

    create_schema = TaskCreate
    update_schema = TaskUpdate
    filter_schema = TaskFilter

    async def read_task_with_sub_tasks(
        self,
        id,
    ) -> TaskModel | None:
        """Get task with their subtasks by id."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.sub_tasks))
        result = await self.db.execute(query)
        if not result:
            raise self.not_found_error(id, "read with sub_tasks")
        return result.scalars().first()

    async def list_tasks_with_sub_tasks(
        self,
        list_filter: filter_schema,
    ) -> List[sqla_model] | None:
        """Get all parents with their children."""
        query = select(self.sqla_model).options(selectinload(self.sqla_model.sub_tasks))
        query = list_filter.filter(query)
        query = list_filter.sort(query)
        results = await self.db.execute(query)
        return results.scalars().all()
