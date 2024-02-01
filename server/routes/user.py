from fastapi import APIRouter, HTTPException,Request,Depends,status,Body
from fastapi.responses import JSONResponse
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from jose import JWTError, jwt
from passlib.context import CryptContext
from models.user import User,UserInDb,Token, TokenData
from config.db import user_collection
from schemas.user import user_schema
from bson import ObjectId
from typing_extensions import Annotated
from datetime import datetime, timedelta, timezone

# VARIABLES
SECRET_KEY = "09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
# user router

userRouter = APIRouter()



pwd_context = CryptContext(schemes=["bcrypt"],deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")



def get_user(username):
     existing_user = user_collection.find_one({"username":username})
     if existing_user:
        user_data = user_schema(existing_user)
        # return UserInDb(**user_data)
        return UserInDb(**user_data)
     
def get_password_hash(password):
    return pwd_context.hash(password)

def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def authenticate_user(username, password):
    existing_user = get_user(username=username)
    if not existing_user:
        return  JSONResponse(content={"message": "This user does not exist, please try to sign up or check your credentials"}, status_code=400)
    if not verify_password(password, existing_user.password):
        return JSONResponse(content={"message": "Wrong password! Please try again "}, status_code=400)
    return existing_user#user_data


def create_access_token(data:dict, expires_delta:timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(timezone.utc) + expires_delta
    else:
        expire = datetime.now(timezone.utc) + timedelta(minutes=15)
    to_encode.update({"exp":expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt


async def get_current_user(token:Annotated[str,Depends(oauth2_scheme)]):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate":"Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        username: str =payload.get("sub")
        if username is None:
            raise credentials_exception
        token_data = TokenData(username=username)
    except JWTError:
        raise credentials_exception
    user  = get_user(token_data.username)
    if user is None:
        raise credentials_exception
    return user


async def  get_current_active_user(current_user:Annotated[User, Depends(get_current_user)]):
    if current_user.disabled:
        return  JSONResponse(content={"message": "Inactive user"}, status_code=400)
    return current_user

@userRouter.post("/token",response_model=Token)
async def login_for_access_token(form_data:Annotated[OAuth2PasswordRequestForm, Depends()]):
    user = authenticate_user(form_data.username, form_data.password)
    print(user)

    if not user:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Incorrect username or password",
            headers={"WWW-Authenticate":"Bearer"}
        )
    access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
    access_token = create_access_token(data={"sub":user.username}, expires_delta=access_token_expires)
    return Token(access_token=access_token, 
                 token_type="bearer", 
                 name=user.name, 
                 username=user.username,
                 password=user.password,
                 address=user.address,
                 status=user.status,
                 id=user.id,
                 disabled=user.disabled
                 )



@userRouter.get("/users/me/", response_model=User)
async def read_users_me(current_user:Annotated[User, Depends(get_current_active_user)]):
    return current_user

@userRouter.post("/api/signup",response_description="New user signup", response_model=User, status_code=status.HTTP_201_CREATED, response_model_by_alias=False)
async def user_signup(user:User = Body(...)):
    existing_user = user_collection.find_one({"username":user.username})

    if existing_user:
        # raise HTTPException(status_code=400, detail="User with same email already exists!")
        return JSONResponse(content={"message": "User with same email already exists"}, status_code=400)
    hashed_password = get_password_hash(user.password)
    new_user_data = User(username=user.username, 
                             name=user.name, 
                             password=hashed_password,
                             address=user.address,
                             status=user.status,
                             disabled=user.disabled)

    new_user =  user_collection.insert_one(new_user_data.model_dump(by_alias=True, exclude=["id"]))
    created_user = user_collection.find_one({"_id": new_user.inserted_id}, {"id": 0})
    return created_user



@userRouter.get("/api/user/{id}", response_description="Get a single user", response_model=User,response_model_by_alias=False)
async def show_user(id:str):
    pass 



@userRouter.put("/{id}")
async def update_user(id:str, user:User):
    user_collection.find_one_and_update({"_id":ObjectId(id)}, {"$set":dict(user)})
    return {"message": f"{id} has been updated"}


@userRouter.delete("/{id}")
async def delete_user(id:str):
    user_collection.find_one_and_delete({"_id":ObjectId(id)})
    return {"message":f"{id} has been deleted" }


