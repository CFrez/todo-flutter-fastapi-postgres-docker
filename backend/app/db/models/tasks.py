"""SQLAlchemy model for a `task` item."""

from sqlalchemy import Column, Date, ForeignKey, String, UUID, Boolean
from sqlalchemy.orm import relationship

from .base import Base


class Task(Base):
    """Database model representing 'task' table in db.

    'id' and 'tablename' are created automatically by 'BaseModel'.
    """

    title = Column(String)
    description = Column(String, nullable=True)
    due_date = Column(Date, nullable=True)
    is_completed = Column(Boolean, default=False)

    # Does this work.....?
    parent_id = Column(UUID, ForeignKey("task.id"), nullable=True)
    parent = relationship("Task", back_populates="sub_tasks")

    sub_tasks = relationship("Task", back_populates="parent")
