SELECT * 
FROM Housing;

--Change SaleDate Format
SELECT SaleDate, CONVERT(Date, SaleDate)
FROM Housing;

--This doesnt work because SQL Server’s CONVERT function doesn’t actually alter the format of the date, it simply converts it to a specific data type.
UPDATE Housing
SET SaleDate = CONVERT(Date, SaleDate);

ALTER TABLE Housing
ADD SaleDateConverted Date;

UPDATE Housing
SET SaleDateConverted = CONVERT(Date, SaleDate);

SELECT SaleDateConverted 
FROM housing;

--Populate property address data
SELECT * 
FROM Housing
order by ParcelID;

Select a.ParcelID, 
	a.PropertyAddress, 
	b.ParcelID, 
	b.PropertyAddress,
	ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing a
Join Housing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From Housing a
Join Housing b
On a.ParcelID = b.ParcelID
And a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null;

--Separate address into columns
Select PropertyAddress 
From Housing;

Select 
	SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) AS Address,
	SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress)) AS Address
	From Housing;

ALTER TABLE Housing
ADD PropertySplitAddress nvarchar(255);

UPDATE Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE Housing
ADD PropertySplitCity nvarchar(255);

UPDATE Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, Len(PropertyAddress));

Select * 
From Housing;

--For Owner address Using Parsename
Select 
	PARSENAME(Replace(OwnerAddress,',','.'), 3),
	PARSENAME(Replace(OwnerAddress,',','.'), 2),
	PARSENAME(Replace(OwnerAddress,',','.'), 1)
	From Housing;

ALTER TABLE Housing
ADD OwnerSplitAddress nvarchar(255);

UPDATE Housing
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'), 3);

ALTER TABLE Housing
ADD OwnerSplitCity nvarchar(255);

UPDATE Housing
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'), 2);

ALTER TABLE Housing
ADD OwnerSplitState nvarchar(255);

UPDATE Housing
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1);

select * from Housing;

--Change Y and N to yes and no in Sold as Vacant field
Select SoldAsVacant 
From Housing
Where SoldAsVacant = 'Y'
Or SoldAsVacant = 'N';

Select Distinct(SoldAsVacant)
From Housing; 

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From Housing
Group by SoldAsVacant
Order by 2; 

Select SoldAsVacant, 
	Case When SoldAsVacant = 'Y' then 'Yes'
		 When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 End
From Housing;

Update Housing
Set SoldAsVacant = Case When SoldAsVacant = 'Y' then 'Yes'
		 When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
		 End;

--Remove Duplpicates
With RowNumCTE AS(
Select *,
	ROW_NUMBER() Over(
	Partition by ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		Order by UniqueID
		) row_num
From Housing
)
Delete From RowNumCTE
Where row_num > 1;

--Delete unused columns
Alter Table Housing
Drop Column OwnerAddress, TaxDistrict, PropertyAddress;

Alter Table Housing
Drop Column SaleDate;

Select * from Housing














