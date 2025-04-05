from setuptools import find_packages, setup

setup(
    name="dagsterdemo",
    packages=find_packages(exclude=["dagsterdemo_tests"]),
    install_requires=[
        "dagster",
        "dagster-cloud"
    ],
    extras_require={"dev": ["dagster-webserver", "pytest"]},
)
