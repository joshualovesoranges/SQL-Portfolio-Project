Select *
From NashvilleHousing



-- Populate Property Address Data

Select *
From NashvilleHousing
--Where PropertyAddress is null
Order By ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


Update a
Set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From NashvilleHousing a
Join NashvilleHousing b
	On a.ParcelID = b.ParcelID
	And a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null



-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From NashvilleHousing
--Where PropertyAddress is null
--Order By ParcelID



Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress)) as Address
From NashvilleHousing



Alter Table NashvilleHousing
add PropertySplitAddress Nvarchar(255)

Update NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)


Alter Table NashvilleHousing
add PropertySplitCity Nvarchar(255)

Update NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, Len(PropertyAddress))








Select OwnerAddress
From NashvilleHousing


Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From NashvilleHousing


Alter Table NashvilleHousing
add OwnerSplitAddress Nvarchar(255)

Alter Table NashvilleHousing
add OwnerSplitCity Nvarchar(255)

Alter Table NashvilleHousing
add OwnerSplitState Nvarchar(255)


Update NashvilleHousing
Set OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)

Update NashvilleHousing
Set OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)

Update NashvilleHousing
Set OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'), 1)





-- Remove Duplicates

With RowNumCTE as 
(Select *,
	ROW_NUMBER() Over (
	Partition By ParcelID,
				 PropertyAddress,
				 SaleDate,
				 SalePrice,
				 LegalReference
				 Order By
					UniqueID
					) row_num
From NashvilleHousing
--Order By ParcelID
)
Delete
From RowNumCTE
Where row_num > 1




-- Delete Unused Columns --


Select *
From NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, PropertyAddress, TaxDistrict, SoldAsVacantConverted



















