// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MedicineIsarCollections.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarUserProfileEntityCollection on Isar {
  IsarCollection<IsarUserProfileEntity> get isarUserProfileEntitys =>
      this.collection();
}

const IsarUserProfileEntitySchema = CollectionSchema(
  name: r'IsarUserProfileEntity',
  id: -6730758881664322877,
  properties: {
    r'ageYears': PropertySchema(
      id: 0,
      name: r'ageYears',
      type: IsarType.long,
    ),
    r'avatarLetter': PropertySchema(
      id: 1,
      name: r'avatarLetter',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 2,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'profileId': PropertySchema(
      id: 3,
      name: r'profileId',
      type: IsarType.string,
    )
  },
  estimateSize: _isarUserProfileEntityEstimateSize,
  serialize: _isarUserProfileEntitySerialize,
  deserialize: _isarUserProfileEntityDeserialize,
  deserializeProp: _isarUserProfileEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'profileId': IndexSchema(
      id: 6052971939042612300,
      name: r'profileId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'profileId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarUserProfileEntityGetId,
  getLinks: _isarUserProfileEntityGetLinks,
  attach: _isarUserProfileEntityAttach,
  version: '3.1.0+1',
);

int _isarUserProfileEntityEstimateSize(
  IsarUserProfileEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.avatarLetter;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.profileId.length * 3;
  return bytesCount;
}

void _isarUserProfileEntitySerialize(
  IsarUserProfileEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.ageYears);
  writer.writeString(offsets[1], object.avatarLetter);
  writer.writeString(offsets[2], object.displayName);
  writer.writeString(offsets[3], object.profileId);
}

IsarUserProfileEntity _isarUserProfileEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarUserProfileEntity();
  object.ageYears = reader.readLongOrNull(offsets[0]);
  object.avatarLetter = reader.readStringOrNull(offsets[1]);
  object.displayName = reader.readString(offsets[2]);
  object.id = id;
  object.profileId = reader.readString(offsets[3]);
  return object;
}

P _isarUserProfileEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarUserProfileEntityGetId(IsarUserProfileEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarUserProfileEntityGetLinks(
    IsarUserProfileEntity object) {
  return [];
}

void _isarUserProfileEntityAttach(
    IsarCollection<dynamic> col, Id id, IsarUserProfileEntity object) {
  object.id = id;
}

extension IsarUserProfileEntityByIndex
    on IsarCollection<IsarUserProfileEntity> {
  Future<IsarUserProfileEntity?> getByProfileId(String profileId) {
    return getByIndex(r'profileId', [profileId]);
  }

  IsarUserProfileEntity? getByProfileIdSync(String profileId) {
    return getByIndexSync(r'profileId', [profileId]);
  }

  Future<bool> deleteByProfileId(String profileId) {
    return deleteByIndex(r'profileId', [profileId]);
  }

  bool deleteByProfileIdSync(String profileId) {
    return deleteByIndexSync(r'profileId', [profileId]);
  }

  Future<List<IsarUserProfileEntity?>> getAllByProfileId(
      List<String> profileIdValues) {
    final values = profileIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'profileId', values);
  }

  List<IsarUserProfileEntity?> getAllByProfileIdSync(
      List<String> profileIdValues) {
    final values = profileIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'profileId', values);
  }

  Future<int> deleteAllByProfileId(List<String> profileIdValues) {
    final values = profileIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'profileId', values);
  }

  int deleteAllByProfileIdSync(List<String> profileIdValues) {
    final values = profileIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'profileId', values);
  }

  Future<Id> putByProfileId(IsarUserProfileEntity object) {
    return putByIndex(r'profileId', object);
  }

  Id putByProfileIdSync(IsarUserProfileEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'profileId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByProfileId(List<IsarUserProfileEntity> objects) {
    return putAllByIndex(r'profileId', objects);
  }

  List<Id> putAllByProfileIdSync(List<IsarUserProfileEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'profileId', objects, saveLinks: saveLinks);
  }
}

extension IsarUserProfileEntityQueryWhereSort
    on QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QWhere> {
  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarUserProfileEntityQueryWhere on QueryBuilder<IsarUserProfileEntity,
    IsarUserProfileEntity, QWhereClause> {
  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      profileIdEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profileId',
        value: [profileId],
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterWhereClause>
      profileIdNotEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [],
              upper: [profileId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [profileId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [profileId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [],
              upper: [profileId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarUserProfileEntityQueryFilter on QueryBuilder<
    IsarUserProfileEntity, IsarUserProfileEntity, QFilterCondition> {
  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> ageYearsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ageYears',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> ageYearsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ageYears',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> ageYearsEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ageYears',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> ageYearsGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ageYears',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> ageYearsLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ageYears',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> ageYearsBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ageYears',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'avatarLetter',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'avatarLetter',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarLetter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'avatarLetter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'avatarLetter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'avatarLetter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'avatarLetter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'avatarLetter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
          QAfterFilterCondition>
      avatarLetterContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'avatarLetter',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
          QAfterFilterCondition>
      avatarLetterMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'avatarLetter',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'avatarLetter',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> avatarLetterIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'avatarLetter',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
          QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
          QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
          QAfterFilterCondition>
      profileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
          QAfterFilterCondition>
      profileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity,
      QAfterFilterCondition> profileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileId',
        value: '',
      ));
    });
  }
}

extension IsarUserProfileEntityQueryObject on QueryBuilder<
    IsarUserProfileEntity, IsarUserProfileEntity, QFilterCondition> {}

extension IsarUserProfileEntityQueryLinks on QueryBuilder<IsarUserProfileEntity,
    IsarUserProfileEntity, QFilterCondition> {}

extension IsarUserProfileEntityQuerySortBy
    on QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QSortBy> {
  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByAgeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByAgeYearsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByAvatarLetter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarLetter', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByAvatarLetterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarLetter', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      sortByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }
}

extension IsarUserProfileEntityQuerySortThenBy
    on QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QSortThenBy> {
  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByAgeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByAgeYearsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ageYears', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByAvatarLetter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarLetter', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByAvatarLetterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'avatarLetter', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QAfterSortBy>
      thenByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }
}

extension IsarUserProfileEntityQueryWhereDistinct
    on QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QDistinct> {
  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QDistinct>
      distinctByAgeYears() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ageYears');
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QDistinct>
      distinctByAvatarLetter({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'avatarLetter', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarUserProfileEntity, IsarUserProfileEntity, QDistinct>
      distinctByProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileId', caseSensitive: caseSensitive);
    });
  }
}

extension IsarUserProfileEntityQueryProperty on QueryBuilder<
    IsarUserProfileEntity, IsarUserProfileEntity, QQueryProperty> {
  QueryBuilder<IsarUserProfileEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarUserProfileEntity, int?, QQueryOperations>
      ageYearsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ageYears');
    });
  }

  QueryBuilder<IsarUserProfileEntity, String?, QQueryOperations>
      avatarLetterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'avatarLetter');
    });
  }

  QueryBuilder<IsarUserProfileEntity, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<IsarUserProfileEntity, String, QQueryOperations>
      profileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileId');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarMedicineEntityCollection on Isar {
  IsarCollection<IsarMedicineEntity> get isarMedicineEntitys =>
      this.collection();
}

const IsarMedicineEntitySchema = CollectionSchema(
  name: r'IsarMedicineEntity',
  id: -6185279002686605405,
  properties: {
    r'categoryFormLabel': PropertySchema(
      id: 0,
      name: r'categoryFormLabel',
      type: IsarType.string,
    ),
    r'createdAtIso': PropertySchema(
      id: 1,
      name: r'createdAtIso',
      type: IsarType.string,
    ),
    r'displayName': PropertySchema(
      id: 2,
      name: r'displayName',
      type: IsarType.string,
    ),
    r'doseAmount': PropertySchema(
      id: 3,
      name: r'doseAmount',
      type: IsarType.double,
    ),
    r'doseMinutesOfDay': PropertySchema(
      id: 4,
      name: r'doseMinutesOfDay',
      type: IsarType.longList,
    ),
    r'doseUnit': PropertySchema(
      id: 5,
      name: r'doseUnit',
      type: IsarType.string,
    ),
    r'durationDayCount': PropertySchema(
      id: 6,
      name: r'durationDayCount',
      type: IsarType.long,
    ),
    r'durationKindName': PropertySchema(
      id: 7,
      name: r'durationKindName',
      type: IsarType.string,
    ),
    r'endDateIso': PropertySchema(
      id: 8,
      name: r'endDateIso',
      type: IsarType.string,
    ),
    r'ingredientLine': PropertySchema(
      id: 9,
      name: r'ingredientLine',
      type: IsarType.string,
    ),
    r'isCriticalMedicine': PropertySchema(
      id: 10,
      name: r'isCriticalMedicine',
      type: IsarType.bool,
    ),
    r'isCustomMedicine': PropertySchema(
      id: 11,
      name: r'isCustomMedicine',
      type: IsarType.bool,
    ),
    r'isPaused': PropertySchema(
      id: 12,
      name: r'isPaused',
      type: IsarType.bool,
    ),
    r'medicineId': PropertySchema(
      id: 13,
      name: r'medicineId',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 14,
      name: r'notes',
      type: IsarType.string,
    ),
    r'profileId': PropertySchema(
      id: 15,
      name: r'profileId',
      type: IsarType.string,
    ),
    r'scheduleKindName': PropertySchema(
      id: 16,
      name: r'scheduleKindName',
      type: IsarType.string,
    ),
    r'schedulePayloadJson': PropertySchema(
      id: 17,
      name: r'schedulePayloadJson',
      type: IsarType.string,
    ),
    r'stockRemaining': PropertySchema(
      id: 18,
      name: r'stockRemaining',
      type: IsarType.double,
    )
  },
  estimateSize: _isarMedicineEntityEstimateSize,
  serialize: _isarMedicineEntitySerialize,
  deserialize: _isarMedicineEntityDeserialize,
  deserializeProp: _isarMedicineEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'medicineId': IndexSchema(
      id: 6094895651756910893,
      name: r'medicineId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'medicineId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'profileId': IndexSchema(
      id: 6052971939042612300,
      name: r'profileId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profileId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarMedicineEntityGetId,
  getLinks: _isarMedicineEntityGetLinks,
  attach: _isarMedicineEntityAttach,
  version: '3.1.0+1',
);

int _isarMedicineEntityEstimateSize(
  IsarMedicineEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.categoryFormLabel.length * 3;
  {
    final value = object.createdAtIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.displayName.length * 3;
  bytesCount += 3 + object.doseMinutesOfDay.length * 8;
  bytesCount += 3 + object.doseUnit.length * 3;
  bytesCount += 3 + object.durationKindName.length * 3;
  {
    final value = object.endDateIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.ingredientLine.length * 3;
  bytesCount += 3 + object.medicineId.length * 3;
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.profileId.length * 3;
  bytesCount += 3 + object.scheduleKindName.length * 3;
  bytesCount += 3 + object.schedulePayloadJson.length * 3;
  return bytesCount;
}

void _isarMedicineEntitySerialize(
  IsarMedicineEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.categoryFormLabel);
  writer.writeString(offsets[1], object.createdAtIso);
  writer.writeString(offsets[2], object.displayName);
  writer.writeDouble(offsets[3], object.doseAmount);
  writer.writeLongList(offsets[4], object.doseMinutesOfDay);
  writer.writeString(offsets[5], object.doseUnit);
  writer.writeLong(offsets[6], object.durationDayCount);
  writer.writeString(offsets[7], object.durationKindName);
  writer.writeString(offsets[8], object.endDateIso);
  writer.writeString(offsets[9], object.ingredientLine);
  writer.writeBool(offsets[10], object.isCriticalMedicine);
  writer.writeBool(offsets[11], object.isCustomMedicine);
  writer.writeBool(offsets[12], object.isPaused);
  writer.writeString(offsets[13], object.medicineId);
  writer.writeString(offsets[14], object.notes);
  writer.writeString(offsets[15], object.profileId);
  writer.writeString(offsets[16], object.scheduleKindName);
  writer.writeString(offsets[17], object.schedulePayloadJson);
  writer.writeDouble(offsets[18], object.stockRemaining);
}

IsarMedicineEntity _isarMedicineEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarMedicineEntity();
  object.categoryFormLabel = reader.readString(offsets[0]);
  object.createdAtIso = reader.readStringOrNull(offsets[1]);
  object.displayName = reader.readString(offsets[2]);
  object.doseAmount = reader.readDouble(offsets[3]);
  object.doseMinutesOfDay = reader.readLongList(offsets[4]) ?? [];
  object.doseUnit = reader.readString(offsets[5]);
  object.durationDayCount = reader.readLongOrNull(offsets[6]);
  object.durationKindName = reader.readString(offsets[7]);
  object.endDateIso = reader.readStringOrNull(offsets[8]);
  object.id = id;
  object.ingredientLine = reader.readString(offsets[9]);
  object.isCriticalMedicine = reader.readBool(offsets[10]);
  object.isCustomMedicine = reader.readBool(offsets[11]);
  object.isPaused = reader.readBool(offsets[12]);
  object.medicineId = reader.readString(offsets[13]);
  object.notes = reader.readStringOrNull(offsets[14]);
  object.profileId = reader.readString(offsets[15]);
  object.scheduleKindName = reader.readString(offsets[16]);
  object.schedulePayloadJson = reader.readString(offsets[17]);
  object.stockRemaining = reader.readDoubleOrNull(offsets[18]);
  return object;
}

P _isarMedicineEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readLongList(offset) ?? []) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readBool(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readString(offset)) as P;
    case 16:
      return (reader.readString(offset)) as P;
    case 17:
      return (reader.readString(offset)) as P;
    case 18:
      return (reader.readDoubleOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarMedicineEntityGetId(IsarMedicineEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarMedicineEntityGetLinks(
    IsarMedicineEntity object) {
  return [];
}

void _isarMedicineEntityAttach(
    IsarCollection<dynamic> col, Id id, IsarMedicineEntity object) {
  object.id = id;
}

extension IsarMedicineEntityByIndex on IsarCollection<IsarMedicineEntity> {
  Future<IsarMedicineEntity?> getByMedicineId(String medicineId) {
    return getByIndex(r'medicineId', [medicineId]);
  }

  IsarMedicineEntity? getByMedicineIdSync(String medicineId) {
    return getByIndexSync(r'medicineId', [medicineId]);
  }

  Future<bool> deleteByMedicineId(String medicineId) {
    return deleteByIndex(r'medicineId', [medicineId]);
  }

  bool deleteByMedicineIdSync(String medicineId) {
    return deleteByIndexSync(r'medicineId', [medicineId]);
  }

  Future<List<IsarMedicineEntity?>> getAllByMedicineId(
      List<String> medicineIdValues) {
    final values = medicineIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'medicineId', values);
  }

  List<IsarMedicineEntity?> getAllByMedicineIdSync(
      List<String> medicineIdValues) {
    final values = medicineIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'medicineId', values);
  }

  Future<int> deleteAllByMedicineId(List<String> medicineIdValues) {
    final values = medicineIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'medicineId', values);
  }

  int deleteAllByMedicineIdSync(List<String> medicineIdValues) {
    final values = medicineIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'medicineId', values);
  }

  Future<Id> putByMedicineId(IsarMedicineEntity object) {
    return putByIndex(r'medicineId', object);
  }

  Id putByMedicineIdSync(IsarMedicineEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'medicineId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMedicineId(List<IsarMedicineEntity> objects) {
    return putAllByIndex(r'medicineId', objects);
  }

  List<Id> putAllByMedicineIdSync(List<IsarMedicineEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'medicineId', objects, saveLinks: saveLinks);
  }
}

extension IsarMedicineEntityQueryWhereSort
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QWhere> {
  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarMedicineEntityQueryWhere
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QWhereClause> {
  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      medicineIdEqualTo(String medicineId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'medicineId',
        value: [medicineId],
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      medicineIdNotEqualTo(String medicineId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [],
              upper: [medicineId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [medicineId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [medicineId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [],
              upper: [medicineId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      profileIdEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profileId',
        value: [profileId],
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterWhereClause>
      profileIdNotEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [],
              upper: [profileId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [profileId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [profileId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [],
              upper: [profileId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarMedicineEntityQueryFilter
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QFilterCondition> {
  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryFormLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'categoryFormLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'categoryFormLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'categoryFormLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'categoryFormLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'categoryFormLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'categoryFormLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'categoryFormLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'categoryFormLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      categoryFormLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'categoryFormLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAtIso',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAtIso',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'createdAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'createdAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      createdAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'createdAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'displayName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'displayName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'displayName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      displayNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'displayName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseAmountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doseAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseAmountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doseAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseAmountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doseAmount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseAmountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doseAmount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doseMinutesOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doseMinutesOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doseMinutesOfDay',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doseMinutesOfDay',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doseMinutesOfDay',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doseMinutesOfDay',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doseMinutesOfDay',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doseMinutesOfDay',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doseMinutesOfDay',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseMinutesOfDayLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'doseMinutesOfDay',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doseUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'doseUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'doseUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'doseUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'doseUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'doseUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'doseUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'doseUnit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'doseUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      doseUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'doseUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationDayCountIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'durationDayCount',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationDayCountIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'durationDayCount',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationDayCountEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationDayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationDayCountGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationDayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationDayCountLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationDayCount',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationDayCountBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationDayCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'durationKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'durationKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'durationKindName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'durationKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'durationKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'durationKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'durationKindName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'durationKindName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      durationKindNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'durationKindName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endDateIso',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endDateIso',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endDateIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endDateIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endDateIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'endDateIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'endDateIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'endDateIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'endDateIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endDateIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      endDateIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'endDateIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingredientLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingredientLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingredientLine',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ingredientLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ingredientLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ingredientLine',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ingredientLine',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingredientLine',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      ingredientLineIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ingredientLine',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      isCriticalMedicineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCriticalMedicine',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      isCustomMedicineEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCustomMedicine',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      isPausedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaused',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicineId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      medicineIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicineId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      profileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduleKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduleKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduleKindName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduleKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduleKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduleKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduleKindName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduleKindName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      scheduleKindNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduleKindName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schedulePayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'schedulePayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'schedulePayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'schedulePayloadJson',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'schedulePayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'schedulePayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'schedulePayloadJson',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'schedulePayloadJson',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'schedulePayloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      schedulePayloadJsonIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'schedulePayloadJson',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      stockRemainingIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stockRemaining',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      stockRemainingIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stockRemaining',
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      stockRemainingEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stockRemaining',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      stockRemainingGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stockRemaining',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      stockRemainingLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stockRemaining',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterFilterCondition>
      stockRemainingBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stockRemaining',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension IsarMedicineEntityQueryObject
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QFilterCondition> {}

extension IsarMedicineEntityQueryLinks
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QFilterCondition> {}

extension IsarMedicineEntityQuerySortBy
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QSortBy> {
  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByCategoryFormLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryFormLabel', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByCategoryFormLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryFormLabel', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByCreatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByCreatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDoseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseAmount', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDoseAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseAmount', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDoseUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseUnit', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDoseUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseUnit', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDurationDayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDayCount', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDurationDayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDayCount', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDurationKindName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationKindName', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByDurationKindNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationKindName', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByEndDateIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateIso', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByEndDateIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateIso', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIngredientLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientLine', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIngredientLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientLine', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIsCriticalMedicine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalMedicine', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIsCriticalMedicineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalMedicine', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIsCustomMedicine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomMedicine', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIsCustomMedicineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomMedicine', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByScheduleKindName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleKindName', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByScheduleKindNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleKindName', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortBySchedulePayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedulePayloadJson', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortBySchedulePayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedulePayloadJson', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByStockRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockRemaining', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      sortByStockRemainingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockRemaining', Sort.desc);
    });
  }
}

extension IsarMedicineEntityQuerySortThenBy
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QSortThenBy> {
  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByCategoryFormLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryFormLabel', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByCategoryFormLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'categoryFormLabel', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByCreatedAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByCreatedAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAtIso', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDisplayName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDisplayNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'displayName', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDoseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseAmount', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDoseAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseAmount', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDoseUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseUnit', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDoseUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'doseUnit', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDurationDayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDayCount', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDurationDayCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationDayCount', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDurationKindName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationKindName', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByDurationKindNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'durationKindName', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByEndDateIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateIso', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByEndDateIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'endDateIso', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIngredientLine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientLine', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIngredientLineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingredientLine', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIsCriticalMedicine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalMedicine', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIsCriticalMedicineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCriticalMedicine', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIsCustomMedicine() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomMedicine', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIsCustomMedicineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCustomMedicine', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByIsPausedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaused', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByScheduleKindName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleKindName', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByScheduleKindNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduleKindName', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenBySchedulePayloadJson() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedulePayloadJson', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenBySchedulePayloadJsonDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'schedulePayloadJson', Sort.desc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByStockRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockRemaining', Sort.asc);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QAfterSortBy>
      thenByStockRemainingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stockRemaining', Sort.desc);
    });
  }
}

extension IsarMedicineEntityQueryWhereDistinct
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct> {
  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByCategoryFormLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'categoryFormLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByCreatedAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAtIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByDisplayName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'displayName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByDoseAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doseAmount');
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByDoseMinutesOfDay() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doseMinutesOfDay');
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByDoseUnit({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'doseUnit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByDurationDayCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationDayCount');
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByDurationKindName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'durationKindName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByEndDateIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endDateIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByIngredientLine({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingredientLine',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByIsCriticalMedicine() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCriticalMedicine');
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByIsCustomMedicine() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCustomMedicine');
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByIsPaused() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaused');
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByMedicineId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicineId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByNotes({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByScheduleKindName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduleKindName',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctBySchedulePayloadJson({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'schedulePayloadJson',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QDistinct>
      distinctByStockRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stockRemaining');
    });
  }
}

extension IsarMedicineEntityQueryProperty
    on QueryBuilder<IsarMedicineEntity, IsarMedicineEntity, QQueryProperty> {
  QueryBuilder<IsarMedicineEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      categoryFormLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'categoryFormLabel');
    });
  }

  QueryBuilder<IsarMedicineEntity, String?, QQueryOperations>
      createdAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAtIso');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      displayNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'displayName');
    });
  }

  QueryBuilder<IsarMedicineEntity, double, QQueryOperations>
      doseAmountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doseAmount');
    });
  }

  QueryBuilder<IsarMedicineEntity, List<int>, QQueryOperations>
      doseMinutesOfDayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doseMinutesOfDay');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      doseUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'doseUnit');
    });
  }

  QueryBuilder<IsarMedicineEntity, int?, QQueryOperations>
      durationDayCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationDayCount');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      durationKindNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'durationKindName');
    });
  }

  QueryBuilder<IsarMedicineEntity, String?, QQueryOperations>
      endDateIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endDateIso');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      ingredientLineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingredientLine');
    });
  }

  QueryBuilder<IsarMedicineEntity, bool, QQueryOperations>
      isCriticalMedicineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCriticalMedicine');
    });
  }

  QueryBuilder<IsarMedicineEntity, bool, QQueryOperations>
      isCustomMedicineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCustomMedicine');
    });
  }

  QueryBuilder<IsarMedicineEntity, bool, QQueryOperations> isPausedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaused');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      medicineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicineId');
    });
  }

  QueryBuilder<IsarMedicineEntity, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      profileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileId');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      scheduleKindNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduleKindName');
    });
  }

  QueryBuilder<IsarMedicineEntity, String, QQueryOperations>
      schedulePayloadJsonProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'schedulePayloadJson');
    });
  }

  QueryBuilder<IsarMedicineEntity, double?, QQueryOperations>
      stockRemainingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stockRemaining');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarDoseOccurrenceEntityCollection on Isar {
  IsarCollection<IsarDoseOccurrenceEntity> get isarDoseOccurrenceEntitys =>
      this.collection();
}

const IsarDoseOccurrenceEntitySchema = CollectionSchema(
  name: r'IsarDoseOccurrenceEntity',
  id: 5698942607289471906,
  properties: {
    r'actionAtIso': PropertySchema(
      id: 0,
      name: r'actionAtIso',
      type: IsarType.string,
    ),
    r'medicineId': PropertySchema(
      id: 1,
      name: r'medicineId',
      type: IsarType.string,
    ),
    r'occurrenceId': PropertySchema(
      id: 2,
      name: r'occurrenceId',
      type: IsarType.string,
    ),
    r'profileId': PropertySchema(
      id: 3,
      name: r'profileId',
      type: IsarType.string,
    ),
    r'scheduledAtIso': PropertySchema(
      id: 4,
      name: r'scheduledAtIso',
      type: IsarType.string,
    ),
    r'snoozedUntilIso': PropertySchema(
      id: 5,
      name: r'snoozedUntilIso',
      type: IsarType.string,
    ),
    r'statusKindName': PropertySchema(
      id: 6,
      name: r'statusKindName',
      type: IsarType.string,
    )
  },
  estimateSize: _isarDoseOccurrenceEntityEstimateSize,
  serialize: _isarDoseOccurrenceEntitySerialize,
  deserialize: _isarDoseOccurrenceEntityDeserialize,
  deserializeProp: _isarDoseOccurrenceEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'occurrenceId': IndexSchema(
      id: 339117606871090824,
      name: r'occurrenceId',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'occurrenceId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'medicineId': IndexSchema(
      id: 6094895651756910893,
      name: r'medicineId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'medicineId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'profileId': IndexSchema(
      id: 6052971939042612300,
      name: r'profileId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'profileId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarDoseOccurrenceEntityGetId,
  getLinks: _isarDoseOccurrenceEntityGetLinks,
  attach: _isarDoseOccurrenceEntityAttach,
  version: '3.1.0+1',
);

int _isarDoseOccurrenceEntityEstimateSize(
  IsarDoseOccurrenceEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.actionAtIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.medicineId.length * 3;
  bytesCount += 3 + object.occurrenceId.length * 3;
  bytesCount += 3 + object.profileId.length * 3;
  bytesCount += 3 + object.scheduledAtIso.length * 3;
  {
    final value = object.snoozedUntilIso;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.statusKindName.length * 3;
  return bytesCount;
}

void _isarDoseOccurrenceEntitySerialize(
  IsarDoseOccurrenceEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actionAtIso);
  writer.writeString(offsets[1], object.medicineId);
  writer.writeString(offsets[2], object.occurrenceId);
  writer.writeString(offsets[3], object.profileId);
  writer.writeString(offsets[4], object.scheduledAtIso);
  writer.writeString(offsets[5], object.snoozedUntilIso);
  writer.writeString(offsets[6], object.statusKindName);
}

IsarDoseOccurrenceEntity _isarDoseOccurrenceEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarDoseOccurrenceEntity();
  object.actionAtIso = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.medicineId = reader.readString(offsets[1]);
  object.occurrenceId = reader.readString(offsets[2]);
  object.profileId = reader.readString(offsets[3]);
  object.scheduledAtIso = reader.readString(offsets[4]);
  object.snoozedUntilIso = reader.readStringOrNull(offsets[5]);
  object.statusKindName = reader.readString(offsets[6]);
  return object;
}

P _isarDoseOccurrenceEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarDoseOccurrenceEntityGetId(IsarDoseOccurrenceEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarDoseOccurrenceEntityGetLinks(
    IsarDoseOccurrenceEntity object) {
  return [];
}

void _isarDoseOccurrenceEntityAttach(
    IsarCollection<dynamic> col, Id id, IsarDoseOccurrenceEntity object) {
  object.id = id;
}

extension IsarDoseOccurrenceEntityByIndex
    on IsarCollection<IsarDoseOccurrenceEntity> {
  Future<IsarDoseOccurrenceEntity?> getByOccurrenceId(String occurrenceId) {
    return getByIndex(r'occurrenceId', [occurrenceId]);
  }

  IsarDoseOccurrenceEntity? getByOccurrenceIdSync(String occurrenceId) {
    return getByIndexSync(r'occurrenceId', [occurrenceId]);
  }

  Future<bool> deleteByOccurrenceId(String occurrenceId) {
    return deleteByIndex(r'occurrenceId', [occurrenceId]);
  }

  bool deleteByOccurrenceIdSync(String occurrenceId) {
    return deleteByIndexSync(r'occurrenceId', [occurrenceId]);
  }

  Future<List<IsarDoseOccurrenceEntity?>> getAllByOccurrenceId(
      List<String> occurrenceIdValues) {
    final values = occurrenceIdValues.map((e) => [e]).toList();
    return getAllByIndex(r'occurrenceId', values);
  }

  List<IsarDoseOccurrenceEntity?> getAllByOccurrenceIdSync(
      List<String> occurrenceIdValues) {
    final values = occurrenceIdValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'occurrenceId', values);
  }

  Future<int> deleteAllByOccurrenceId(List<String> occurrenceIdValues) {
    final values = occurrenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'occurrenceId', values);
  }

  int deleteAllByOccurrenceIdSync(List<String> occurrenceIdValues) {
    final values = occurrenceIdValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'occurrenceId', values);
  }

  Future<Id> putByOccurrenceId(IsarDoseOccurrenceEntity object) {
    return putByIndex(r'occurrenceId', object);
  }

  Id putByOccurrenceIdSync(IsarDoseOccurrenceEntity object,
      {bool saveLinks = true}) {
    return putByIndexSync(r'occurrenceId', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByOccurrenceId(
      List<IsarDoseOccurrenceEntity> objects) {
    return putAllByIndex(r'occurrenceId', objects);
  }

  List<Id> putAllByOccurrenceIdSync(List<IsarDoseOccurrenceEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'occurrenceId', objects, saveLinks: saveLinks);
  }
}

extension IsarDoseOccurrenceEntityQueryWhereSort on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QWhere> {
  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarDoseOccurrenceEntityQueryWhere on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QWhereClause> {
  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> occurrenceIdEqualTo(String occurrenceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'occurrenceId',
        value: [occurrenceId],
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> occurrenceIdNotEqualTo(String occurrenceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurrenceId',
              lower: [],
              upper: [occurrenceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurrenceId',
              lower: [occurrenceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurrenceId',
              lower: [occurrenceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'occurrenceId',
              lower: [],
              upper: [occurrenceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> medicineIdEqualTo(String medicineId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'medicineId',
        value: [medicineId],
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> medicineIdNotEqualTo(String medicineId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [],
              upper: [medicineId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [medicineId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [medicineId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'medicineId',
              lower: [],
              upper: [medicineId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> profileIdEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'profileId',
        value: [profileId],
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterWhereClause> profileIdNotEqualTo(String profileId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [],
              upper: [profileId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [profileId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [profileId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'profileId',
              lower: [],
              upper: [profileId],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarDoseOccurrenceEntityQueryFilter on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QFilterCondition> {
  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'actionAtIso',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'actionAtIso',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actionAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actionAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actionAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actionAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actionAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      actionAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actionAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      actionAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actionAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actionAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> actionAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actionAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'medicineId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      medicineIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'medicineId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      medicineIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'medicineId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'medicineId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> medicineIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'medicineId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurrenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'occurrenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'occurrenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'occurrenceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'occurrenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'occurrenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      occurrenceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'occurrenceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      occurrenceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'occurrenceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'occurrenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> occurrenceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'occurrenceId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'profileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      profileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'profileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      profileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'profileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'profileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> profileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'profileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scheduledAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scheduledAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scheduledAtIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'scheduledAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'scheduledAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      scheduledAtIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'scheduledAtIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      scheduledAtIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'scheduledAtIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scheduledAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> scheduledAtIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'scheduledAtIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'snoozedUntilIso',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'snoozedUntilIso',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'snoozedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'snoozedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'snoozedUntilIso',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'snoozedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'snoozedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      snoozedUntilIsoContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'snoozedUntilIso',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      snoozedUntilIsoMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'snoozedUntilIso',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'snoozedUntilIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> snoozedUntilIsoIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'snoozedUntilIso',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'statusKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'statusKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'statusKindName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'statusKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'statusKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      statusKindNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'statusKindName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
          QAfterFilterCondition>
      statusKindNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'statusKindName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'statusKindName',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity,
      QAfterFilterCondition> statusKindNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'statusKindName',
        value: '',
      ));
    });
  }
}

extension IsarDoseOccurrenceEntityQueryObject on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QFilterCondition> {}

extension IsarDoseOccurrenceEntityQueryLinks on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QFilterCondition> {}

extension IsarDoseOccurrenceEntityQuerySortBy on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QSortBy> {
  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByActionAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionAtIso', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByActionAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionAtIso', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByOccurrenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceId', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByOccurrenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceId', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByScheduledAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtIso', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByScheduledAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtIso', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortBySnoozedUntilIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntilIso', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortBySnoozedUntilIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntilIso', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByStatusKindName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKindName', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      sortByStatusKindNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKindName', Sort.desc);
    });
  }
}

extension IsarDoseOccurrenceEntityQuerySortThenBy on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QSortThenBy> {
  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByActionAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionAtIso', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByActionAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actionAtIso', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByMedicineId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByMedicineIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'medicineId', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByOccurrenceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceId', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByOccurrenceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'occurrenceId', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByProfileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByProfileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'profileId', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByScheduledAtIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtIso', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByScheduledAtIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'scheduledAtIso', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenBySnoozedUntilIso() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntilIso', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenBySnoozedUntilIsoDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'snoozedUntilIso', Sort.desc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByStatusKindName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKindName', Sort.asc);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QAfterSortBy>
      thenByStatusKindNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'statusKindName', Sort.desc);
    });
  }
}

extension IsarDoseOccurrenceEntityQueryWhereDistinct on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct> {
  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctByActionAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actionAtIso', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctByMedicineId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'medicineId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctByOccurrenceId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'occurrenceId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctByProfileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'profileId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctByScheduledAtIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'scheduledAtIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctBySnoozedUntilIso({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'snoozedUntilIso',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QDistinct>
      distinctByStatusKindName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'statusKindName',
          caseSensitive: caseSensitive);
    });
  }
}

extension IsarDoseOccurrenceEntityQueryProperty on QueryBuilder<
    IsarDoseOccurrenceEntity, IsarDoseOccurrenceEntity, QQueryProperty> {
  QueryBuilder<IsarDoseOccurrenceEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String?, QQueryOperations>
      actionAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actionAtIso');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String, QQueryOperations>
      medicineIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'medicineId');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String, QQueryOperations>
      occurrenceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'occurrenceId');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String, QQueryOperations>
      profileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'profileId');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String, QQueryOperations>
      scheduledAtIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'scheduledAtIso');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String?, QQueryOperations>
      snoozedUntilIsoProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'snoozedUntilIso');
    });
  }

  QueryBuilder<IsarDoseOccurrenceEntity, String, QQueryOperations>
      statusKindNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'statusKindName');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarAppMetaEntityCollection on Isar {
  IsarCollection<IsarAppMetaEntity> get isarAppMetaEntitys => this.collection();
}

const IsarAppMetaEntitySchema = CollectionSchema(
  name: r'IsarAppMetaEntity',
  id: -8950986501642521764,
  properties: {
    r'metaKey': PropertySchema(
      id: 0,
      name: r'metaKey',
      type: IsarType.string,
    ),
    r'metaValue': PropertySchema(
      id: 1,
      name: r'metaValue',
      type: IsarType.string,
    )
  },
  estimateSize: _isarAppMetaEntityEstimateSize,
  serialize: _isarAppMetaEntitySerialize,
  deserialize: _isarAppMetaEntityDeserialize,
  deserializeProp: _isarAppMetaEntityDeserializeProp,
  idName: r'id',
  indexes: {
    r'metaKey': IndexSchema(
      id: 3075079648484274111,
      name: r'metaKey',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'metaKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _isarAppMetaEntityGetId,
  getLinks: _isarAppMetaEntityGetLinks,
  attach: _isarAppMetaEntityAttach,
  version: '3.1.0+1',
);

int _isarAppMetaEntityEstimateSize(
  IsarAppMetaEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.metaKey.length * 3;
  bytesCount += 3 + object.metaValue.length * 3;
  return bytesCount;
}

void _isarAppMetaEntitySerialize(
  IsarAppMetaEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.metaKey);
  writer.writeString(offsets[1], object.metaValue);
}

IsarAppMetaEntity _isarAppMetaEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarAppMetaEntity();
  object.id = id;
  object.metaKey = reader.readString(offsets[0]);
  object.metaValue = reader.readString(offsets[1]);
  return object;
}

P _isarAppMetaEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarAppMetaEntityGetId(IsarAppMetaEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarAppMetaEntityGetLinks(
    IsarAppMetaEntity object) {
  return [];
}

void _isarAppMetaEntityAttach(
    IsarCollection<dynamic> col, Id id, IsarAppMetaEntity object) {
  object.id = id;
}

extension IsarAppMetaEntityByIndex on IsarCollection<IsarAppMetaEntity> {
  Future<IsarAppMetaEntity?> getByMetaKey(String metaKey) {
    return getByIndex(r'metaKey', [metaKey]);
  }

  IsarAppMetaEntity? getByMetaKeySync(String metaKey) {
    return getByIndexSync(r'metaKey', [metaKey]);
  }

  Future<bool> deleteByMetaKey(String metaKey) {
    return deleteByIndex(r'metaKey', [metaKey]);
  }

  bool deleteByMetaKeySync(String metaKey) {
    return deleteByIndexSync(r'metaKey', [metaKey]);
  }

  Future<List<IsarAppMetaEntity?>> getAllByMetaKey(List<String> metaKeyValues) {
    final values = metaKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'metaKey', values);
  }

  List<IsarAppMetaEntity?> getAllByMetaKeySync(List<String> metaKeyValues) {
    final values = metaKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'metaKey', values);
  }

  Future<int> deleteAllByMetaKey(List<String> metaKeyValues) {
    final values = metaKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'metaKey', values);
  }

  int deleteAllByMetaKeySync(List<String> metaKeyValues) {
    final values = metaKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'metaKey', values);
  }

  Future<Id> putByMetaKey(IsarAppMetaEntity object) {
    return putByIndex(r'metaKey', object);
  }

  Id putByMetaKeySync(IsarAppMetaEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'metaKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByMetaKey(List<IsarAppMetaEntity> objects) {
    return putAllByIndex(r'metaKey', objects);
  }

  List<Id> putAllByMetaKeySync(List<IsarAppMetaEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'metaKey', objects, saveLinks: saveLinks);
  }
}

extension IsarAppMetaEntityQueryWhereSort
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QWhere> {
  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarAppMetaEntityQueryWhere
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QWhereClause> {
  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      metaKeyEqualTo(String metaKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'metaKey',
        value: [metaKey],
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterWhereClause>
      metaKeyNotEqualTo(String metaKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'metaKey',
              lower: [],
              upper: [metaKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'metaKey',
              lower: [metaKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'metaKey',
              lower: [metaKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'metaKey',
              lower: [],
              upper: [metaKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarAppMetaEntityQueryFilter
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QFilterCondition> {
  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metaKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metaKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metaKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metaKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metaKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metaKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metaKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metaKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metaKey',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metaKey',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metaValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'metaValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'metaValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'metaValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'metaValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'metaValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'metaValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'metaValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'metaValue',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterFilterCondition>
      metaValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'metaValue',
        value: '',
      ));
    });
  }
}

extension IsarAppMetaEntityQueryObject
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QFilterCondition> {}

extension IsarAppMetaEntityQueryLinks
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QFilterCondition> {}

extension IsarAppMetaEntityQuerySortBy
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QSortBy> {
  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      sortByMetaKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaKey', Sort.asc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      sortByMetaKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaKey', Sort.desc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      sortByMetaValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaValue', Sort.asc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      sortByMetaValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaValue', Sort.desc);
    });
  }
}

extension IsarAppMetaEntityQuerySortThenBy
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QSortThenBy> {
  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      thenByMetaKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaKey', Sort.asc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      thenByMetaKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaKey', Sort.desc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      thenByMetaValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaValue', Sort.asc);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QAfterSortBy>
      thenByMetaValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'metaValue', Sort.desc);
    });
  }
}

extension IsarAppMetaEntityQueryWhereDistinct
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QDistinct> {
  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QDistinct>
      distinctByMetaKey({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metaKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QDistinct>
      distinctByMetaValue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'metaValue', caseSensitive: caseSensitive);
    });
  }
}

extension IsarAppMetaEntityQueryProperty
    on QueryBuilder<IsarAppMetaEntity, IsarAppMetaEntity, QQueryProperty> {
  QueryBuilder<IsarAppMetaEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarAppMetaEntity, String, QQueryOperations> metaKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metaKey');
    });
  }

  QueryBuilder<IsarAppMetaEntity, String, QQueryOperations>
      metaValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'metaValue');
    });
  }
}
