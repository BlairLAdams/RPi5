from setuptools import find_packages, setup

setup(
    name="water_quality",
    packages=find_packages(exclude=["water_quality_tests"]),
    install_requires=[
        "dagster",
        "dagster-cloud"
    ],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
