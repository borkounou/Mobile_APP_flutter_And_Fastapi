from pydantic import BaseModel, EmailStr, constr,Field, ConfigDict
from pydantic.functional_validators import BeforeValidator
from typing_extensions import Annotated
from typing import Optional,List

PyObjectId = Annotated[str, BeforeValidator(str)]

class User(BaseModel):
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    username: EmailStr = Field(...)
    access_token:str
    token_type:str=Field(default="bearer")
    name: str = Field(...)
    password:constr(min_length=4, max_length=70) = Field(title="password")
    address:str = Field(default="")
    status: str =Field(default="user")
    disabled:bool = Field(default=False)
    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "username": "jdoe@example.com",

                "password":"bblaldadarar",
                "name": "Jane Doe",
                "address": "2 rue de Sebastien",
                "status": "user",
                "disabled":False
            
            }
        },
    )


class Token(BaseModel):
    access_token:str
    token_type:str=Field(default="bearer")
    id: Optional[PyObjectId] = Field(alias="_id", default=None)
    username: EmailStr = Field(...)#constr(strip_whitespace=True, min_length=2, max_length=30)
    name: str = Field(...)
    password:constr(min_length=4, max_length=70) = Field(title="password")
    address:str = Field(default="")
    status: str =Field(default="user")
    disabled:bool = Field(default=False)
    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "username": "jdoe@example.com",
                "access_token":"access_token",
                "token_type":"bearer",
                "password":"bblaldadarar",
                "name": "Jane Doe",
                "address": "2 rue de Sebastien",
                "status": "user",
                # "disabled":False
            
            }
        },
    )
    

class TokenData(BaseModel):
    username:str | None = None

class UserInDb(User):
    password:str#constr(min_length=4, max_length=70) = Field(title="password")



class UserUpdateModel(BaseModel):

    username: Optional[str] = None
    email: Optional[EmailStr] = None
    address: Optional[str] = None
    status: Optional[str] = None
    disabled:Optional[bool] =None
    model_config = ConfigDict(
        populate_by_name=True,
        arbitrary_types_allowed=True,
        json_schema_extra={
            "example": {
                "username": "Jane Doe",
                "email": "jdoe@example.com",
                "address": "2 rue de Sebastien",
                "status": "user",
                "disabled":False
            
            }
        },
    )


class UserCollection(BaseModel):
    users: List[User]
    