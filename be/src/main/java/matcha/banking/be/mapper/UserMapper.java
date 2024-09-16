package matcha.banking.be.mapper;

import matcha.banking.be.dto.GetUserInfoDto;
import matcha.banking.be.entity.UserEntity;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface UserMapper {

    GetUserInfoDto entityToDto(UserEntity userEntity);

    UserEntity dtoToEntity(GetUserInfoDto getUserInfoDto);
}
