"""Define metadata for tags used in OpenAPI documentation."""

from typing import Optional

from app.api.schemas.base import BaseSchema


## ===== Tags MetaData Schema ===== ##
class ExternalDocs(BaseSchema):

    description: Optional[str] = None
    ulr: str


class MetaDataTag(BaseSchema):

    name: str
    description: Optional[str] = None
    external_docs: Optional[ExternalDocs] = None

    class Config:
        populate_by_name = True


## ===== Tags Metadata Definition ===== ##
tasks_tag = MetaDataTag(name="tasks", description="All tasks that need to be done.")

metadata_tags = [tasks_tag]
