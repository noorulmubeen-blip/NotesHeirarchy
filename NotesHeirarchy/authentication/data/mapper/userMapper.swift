//
//  userMapper.swift
//  NotesHeirarchy
//
//  Created by Noor ul Mubeen on 17/11/2025.
//

class UserMapper{
    static func fromDomain(_ user: User) -> RemoteUserDto {
        return RemoteUserDto(id: user.id, username: user.name, email: user.email,
                             firstName: user.firstName, lastName: user.lastName,
                             gender: user.gender, image: user.image,accessToken: "",
                             refreshToken: "")
    }
    
    static func toDomain(_ user: RemoteUserDto) -> User {
        return User(id: user.id,name: user.username,  email: user.email,
                    firstName: user.firstName, lastName: user.lastName,
                    gender: user.gender, image: user.image)
    }
}
