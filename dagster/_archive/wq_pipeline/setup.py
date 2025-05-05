from setuptools import find_packages, setup

setup(
    name="wq_pipeline",
    packages=find_packages(exclude=["wq_pipeline_tests"]),
    install_requires=[
        "dagster",
        "dagster-cloud"
    ],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
