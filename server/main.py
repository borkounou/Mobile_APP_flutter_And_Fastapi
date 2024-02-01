from fastapi import FastAPI
from routes.user import userRouter

app = FastAPI()



# Routers
app.include_router(userRouter)

