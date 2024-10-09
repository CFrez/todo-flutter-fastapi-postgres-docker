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
        allow_population_by_field_name = True
        fields = {"external_docs": {"alias": "externalDocs"}}


## ===== Tags Metadata Definition ===== ##
tasks_tag = MetaDataTag(name="tasks", description="All tasks that need to be done.")

metadata_tags = [tasks_tag]
