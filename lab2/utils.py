import shutil
import subprocess
import numpy as np
import matplotlib.pyplot as plt
import SimpleITK as sitk
from pathlib import Path
from typing import List


def elastix_wrapper(
    fix_img_path: Path,
    mov_img_path: Path,
    res_path: Path,
    parameters_path: Path,
    keep_just_useful_files: bool = True
):
    """Wraps Elastix command line interface into a python function
    Args:
        fix_img_path (Path): Path to the fix image
        mov_img_path (Path): Path to the moving image
        res_path (Path): Path where to store the register image and transformation parameters
        parameters_path (Path): Path to the parameters map file
        keep_just_useful_files (bool, optional): Wheter to delete the rubish Elastix outputs.
            Defaults to True.
    Returns:
        (Path): Path where the transformation matrix is stored
    """
    # Fix filenames and create folders
    mov_img_name = mov_img_path.name.split(".")[0]
    if res_path.name.endswith('.img') or ('.nii' in res_path.name):
        res_filename = f'{res_path.name.split(".")[0]}.nii.gz'
        res_path = res_path.parent / 'res_tmp'
    else:
        res_filename = f'{mov_img_name}.nii.gz'
        res_path = res_path / 'res_tmp'
    res_path.mkdir(exist_ok=True, parents=True)

    # Run elastix
    subprocess.call([
        'elastix', '-out', str(res_path), '-f', str(fix_img_path), '-m',
        str(mov_img_path), '-p', str(parameters_path)
    ])

    # Fix resulting filenames
    (res_path/'result.0.nii.gz').rename(res_path.parent/res_filename)
    transformation_file_name = f'TransformParameters_{mov_img_name}.txt'
    (res_path/'TransformParameters.0.txt').rename(res_path.parent/transformation_file_name)

    if keep_just_useful_files:
        shutil.rmtree(res_path)

    return res_path.parent/transformation_file_name


def transformix_wrapper(
    mov_img_path: Path,
    res_path: Path,
    transformation_path: Path,
    keep_just_useful_files: bool = True
):
    """Wraps elastix command line interfase into a python function
    Args:
        mov_img_path (Path): Path to the moving image
        res_path (Path): Path where to store the register image and transformation parameters
        transformation_path (Path): Path to the transformation map file
        keep_just_useful_files (bool, optional): Wheter to delete the rubish Elastix outputs.
            Defaults to True.
    """
    # Fix filenames and create folders
    if res_path.name.endswith('.img') or ('.nii' in res_path.name):
        res_filename = f'{res_path.name.split(".")[0]}.nii.gz'
        res_path = res_path.parent / 'res_tmp'
    else:
        mov_img_name = mov_img_path.name.split(".")[0]
        res_filename = f'{mov_img_name}.nii.gz'
        res_path = res_path / 'res_tmp'
    res_path.mkdir(exist_ok=True, parents=True)

    # Run transformix
    subprocess.call([
        'transformix', '-out', str(res_path), '-in', str(mov_img_path),
        '-tp', str(transformation_path)
    ])

    # Fix resulting filenames
    (res_path/'result.nii.gz').rename(res_path.parent/res_filename)
    if keep_just_useful_files:
        shutil.rmtree(res_path)


def modify_field_parameter_map(
    field_value_list: List[tuple], in_par_map_path: Path, out_par_map_path: Path = None
):
    """Modifies the parameter including/overwriting the Field/Value pairs passed
    Args:
        field_value_list (List[tuple]): List of (Field, Value) pairs to modify
        in_par_map_path (Path): Path to the original parameter file
        out_par_map_path (Path, optional): Path to the destiny parameter file
            if None, then the original is overwritten. Defaults to None.
    """
    pm = sitk.ReadParameterFile(str(in_par_map_path))
    for [field, value] in field_value_list:
        pm[field] = (value, )
    out_par_map_path = in_par_map_path if out_par_map_path is None else out_par_map_path
    sitk.WriteParameterFile(pm, str(out_par_map_path))


def mutual_information(vol1: np.ndarray, vol2: np.ndarray):
    """Computes the mutual information between two images/volumes
    Args:
        vol1 (np.ndarray): First of two image/volumes to compare
        vol2 (np.ndarray): Second of two image/volumes to compare
    Returns:
        (float): Mutual information
    """
    # Get the histogram
    hist_2d, x_edges, y_edges = np.histogram2d(
        vol1.ravel(), vol2.ravel(), bins=255)
    # Get pdf
    pxy = hist_2d / float(np.sum(hist_2d))
    # Marginal pdf for x over y
    px = np.sum(pxy, axis=1)
    # Marginal pdf for y over x
    py = np.sum(pxy, axis=0)
    px_py = px[:, None] * py[None, :]
    nzs = pxy > 0
    return np.sum(pxy[nzs] * np.log(pxy[nzs] / px_py[nzs]))


def min_max_norm(img: np.ndarray, max_val: int = None, dtype: str = None):
    """
    Scales images to be in range [0, 2**bits]

    Args:
        img (np.ndarray): Image to be scaled.
        max_val (int, optional): Value to scale images
            to after normalization. Defaults to None.
        dtype (str, optional): Output datatype

    Returns:
        np.ndarray: Scaled image with values from [0, max_val]
    """
    if max_val is None:
        max_val = np.iinfo(img.dtype).max
    img = (img - img.min()) / (img.max() - img.min()) * max_val
    if dtype is not None:
        return img.astype(dtype)
    else:
        return img


def save_segementations(
    volume: np.ndarray, reference: sitk.Image, filepath: Path
):
    """Stores the volume in nifty format using the spatial parameters coming
        from a reference image
    Args:
        volume (np.ndarray): Volume to store as in Nifty format
        reference (sitk.Image): Reference image to get the spatial parameters from.
        filepath (Path): Where to save the volume.
    """
    # Save image
    img = sitk.GetImageFromArray(volume)
    img.SetDirection(reference.GetDirection())
    img.SetOrigin(reference.GetOrigin())
    img.SetSpacing(reference.GetSpacing())
    sitk.WriteImage(img, str(filepath))


def complete_figure(data_path: Path, img_names: List[Path], titles: List[str]):
    """Plots a huge figure with all image names from all modalities.
    Args:
        data_path (Path): Common path among the images
        img_names (List[Path]): File paths to read the images from
        titles (List[str]): Modality
    """
    img = sitk.ReadImage(str(data_path/img_names[0]))
    img_array = sitk.GetArrayFromImage(img)
    img_array = img_array[::-1, ::-1, ::-1]

    fig, ax = plt.subplots(7, len(img_names), figsize=(10, 14))
    for i, slice_n in enumerate(np.linspace(70, (img_array.shape[0] - 70), 7).astype('int')):
        for j, img_name in enumerate(img_names):
            img = sitk.ReadImage(str(data_path/img_name))
            img_array = sitk.GetArrayFromImage(img)
            if i == 6:
                ax[i, j].set_xlabel(titles[j])
            if i == 0:
                ax[i, j].set_title(titles[j])
            if j in [0, 1]:
                ax[i, j].imshow(img_array[slice_n, :, :], cmap='gray')
            else:
                ax[i, j].imshow(img_array[slice_n, :, :])
            ax[i, j].set_xticks([])
            ax[i, j].set_yticks([])
            if j == 0:
                ax[i, j].set_ylabel(f'Slice {slice_n}')
    plt.show()
