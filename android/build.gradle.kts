allprojects {
    repositories {
        google()
        mavenCentral()
    }

    // --- ここからが修正箇所です ---
    // プロジェクト全体のJavaコンパイル設定をバージョン17に統一します。
    // これにより、プラグイン内でのJavaとKotlinのバージョン不整合が解消されます。
    tasks.withType(JavaCompile::class.java).configureEach {
        options.release.set(17)
    }
}

// Add this block
subprojects {
    afterEvaluate {
        extensions.findByType<com.android.build.gradle.BaseExtension>()?.apply {
            ndkVersion = "27.0.12077973"
        }
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}

// ★前回追加した、JavaCompileとKotlinCompileを設定するsubprojectsブロックは削除しました。