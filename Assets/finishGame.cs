using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class finishGame : MonoBehaviour
{

    public string sceneName; // Nome da cena a ser carregada

    private void OnCollisionEnter(Collision collision)
    {
        // Verifica se ocorreu uma colisão com o jogador
        if (collision.gameObject.CompareTag("Player"))
        {
            // Carrega a nova cena
            SceneManager.LoadScene(sceneName);
        }
    }
}
