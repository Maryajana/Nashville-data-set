SELECT saledatechanged, convert(date, saledate) as Date
  FROM [portfolio_project].[dbo].[Nashvillehousing];

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set SaleDate = convert(date, saledate);

  alter table Nashvillehousing
  add saledatechanged date;

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set saledatechanged = convert(date, saledate);


  --property address (update null)
  SELECT *
  FROM [portfolio_project].[dbo].[Nashvillehousing]
  --where propertyaddress is null
  order by parcelID;

  SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.ParcelID, ISNULL(a.propertyaddress, b.PropertyAddress)
  FROM [portfolio_project].[dbo].[Nashvillehousing] a
  JOIN portfolio_project.dbo.Nashvillehousing b
  ON a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null;

  update a
  set propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
  FROM [portfolio_project].[dbo].[Nashvillehousing] a
  JOIN portfolio_project.dbo.Nashvillehousing b
  ON a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
  where a.PropertyAddress is null;

  ----address break out----

   SELECT PropertyAddress
  FROM [portfolio_project].[dbo].[Nashvillehousing]
  --where propertyaddress is null
  --order by parcelID;

  select SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address,
  SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress)) as Streetname
  FROM [portfolio_project].[dbo].[Nashvillehousing];

  alter table [portfolio_project].[dbo].[Nashvillehousing]
  add homeaddress Nvarchar(255);

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set homeaddress = SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1)

   alter table [portfolio_project].[dbo].[Nashvillehousing]
  add cityname varchar(255);

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set cityname = SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress)+1, LEN(propertyaddress));

  SELECT OwnerAddress
  FROM [portfolio_project].[dbo].[Nashvillehousing];

  select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3) as OwnerHomeAddress 
  , PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2 ) as OwnerCity
  , PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1) as OwnerState  
   FROM [portfolio_project].[dbo].[Nashvillehousing];

   alter table [portfolio_project].[dbo].[Nashvillehousing]
  add Ownerhomeaddress Nvarchar(255);

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set Ownerhomeaddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3);

  alter table [portfolio_project].[dbo].[Nashvillehousing]
  add OwnerCity Nvarchar(255);

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set OwnerCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2 );

  alter table [portfolio_project].[dbo].[Nashvillehousing]
  add OwnerState Nvarchar(255);

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set OwnerState =PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1);

   --change Y and N to yes and No in "sold as Vacant" field---

   select soldasvacant,
   case when SoldAsVacant = 'Y' then 'Yes'
   when SoldAsVacant = 'N' then 'No'
   else SoldAsVacant
   END
   FROM [portfolio_project].[dbo].[Nashvillehousing];

  Update [portfolio_project].[dbo].[Nashvillehousing]
  set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
   when SoldAsVacant = 'N' then 'No'
   else SoldAsVacant
   END;

   SELECT distinct SoldAsVacant, count(SoldAsVacant)
  FROM [portfolio_project].[dbo].[Nashvillehousing];

  ---------------------------------------------------------------------------------------------------------------
  --Remove Duplicates
   SELECT *
  FROM [portfolio_project].[dbo].[Nashvillehousing];

  select *, 
  ROW_NUMBER()over(
  partition by ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  Order by 
  UniqueID
  ) row_num
   FROM [portfolio_project].[dbo].[Nashvillehousing];

    with Dup_row as(
  select *, 
  ROW_NUMBER()over(
  partition by ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  Order by 
  UniqueID
  ) row_num
   FROM [portfolio_project].[dbo].[Nashvillehousing]
   )
   select * 
   from Dup_row
   where row_num >1
   order by PropertyAddress;

    with Dup_row as(
  select *, 
  ROW_NUMBER()over(
  partition by ParcelID,
  PropertyAddress,
  SalePrice,
  SaleDate,
  LegalReference
  Order by 
  UniqueID
  ) row_num
   FROM [portfolio_project].[dbo].[Nashvillehousing]
   )
   delete 
   from Dup_row
   where row_num >1
   --order by PropertyAddress;


   ----- delete unused column------
      SELECT *
  FROM [portfolio_project].[dbo].[Nashvillehousing];

  alter table [portfolio_project].[dbo].[Nashvillehousing]
  drop column saledate, owneraddress, taxdistrict, propertyaddress