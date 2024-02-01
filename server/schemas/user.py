def user_schema(user) -> dict:
    return {
        "id": str(user["_id"]),
        "username": user["username"],
        "name": user["name"],
        "password":user["password"],
        "address":user["address"],
        "status":user["status"],
        "disabled": user["disabled"],
    }




def token_schema(token)->dict:
    return {
          "access_token":token["access_token"],
          "token_type":"bearer"
    }


def list_serial_user(users) ->list:
    return [user_schema(user) for user in users]